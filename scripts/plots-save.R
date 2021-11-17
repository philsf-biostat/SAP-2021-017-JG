# setup -------------------------------------------------------------------
height <- 8
width <- 8
units <- "cm"

# publication ready tables ------------------------------------------------

# Don't need to version these files on git
# tab_inf %>%
#   as_gt() %>%
#   as_rtf() %>%
#   writeLines(con = "report/SAR-2021-017-JG-v01-T2.rtf")

# save plots --------------------------------------------------------------

ggsave(filename = "figures/hiper.png", plot = gg.hiper, height = 16, width = 16, units = units)

png("figures/sil_final.png", width = 16, height = 16, units = units, res = 600)
final_sil %>% plot(main="")
dev.off()

png("figures/sil_rej.png", width = 16, height = 12, units = units, res = 600)
final_sil.rej %>% plot(main="")
dev.off()
