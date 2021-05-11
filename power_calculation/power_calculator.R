#adapted from https://github.com/jenlij/GAS-power-calculator/blob/master/gas_power_calculator.js

library(data.table)



calculate <-  function(ncases, ncontrols, freq, risk, prevalence, alpha){

	#Genotype frequencies
	p <- c(freq * freq, 2 * freq * (1 - freq), (1 - freq) * (1 - freq))

    #genotype probabilities
    f <- c(risk * risk, risk, 1.0)

    scale <- prevalence / (f[1]*p[1] + f[2]*p[2] + f[3]*p[3])

    #Adjusted penetrances
    f <- f * scale

    C <- - qnorm(alpha * 0.5)
    pcases <- (f[1] * p[1] + f[2] * p[2] * 0.5) / prevalence #disease allele freq cases
    pcontrols <- ( (1 - f[1]) * p[1] + (1 - f[2]) * p[2] * 0.5) / (1 - prevalence) #disease allele freq controls
    vcases <- pcases * (1 - pcases)
    vcontrols <- pcontrols * (1 - pcontrols)
    ncp <- (pcases - pcontrols) / sqrt( (vcases / ncases + vcontrols / ncontrols) * 0.5 )
    P <- pnorm(-C - ncp) + pnorm(-C + ncp) #results power

    return(P)
}



meta5 <- fread("META5Loci.csv")

variant_data <- fread("risk_variant_pop_freqs.csv")
variant_data$AFF <- Reduce(rbind, lapply(lapply(strsplit(variant_data$AFF, "/"), as.numeric), sum))
variant_data$UNAFF <- Reduce(rbind, lapply(lapply(strsplit(variant_data$UNAFF, "/"), as.numeric), sum))
meta5$row_order <- as.numeric(rownames(meta5))

#Select columns of interest
dat <- merge(meta5[, c("RSID", "OR", "row_order")], variant_data[,c("RSID", "AFF", "UNAFF", "European (non-Finnish)")])
dat <- dat[order(dat$row_order),]

results <- lapply(1:nrow(dat), function(i){
	power <- calculate(dat$AFF[i], dat$UNAFF[i], dat$"European (non-Finnish)"[i], dat$OR[i], 0.005, 5e-8)
	rsid <- dat$RSID[i]
	return(data.frame(rsid, power))
	})

write.csv(Reduce(rbind, results), file = "variant_power.csv", quote = FALSE, row.names = FALSE)
