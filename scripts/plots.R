# setup -------------------------------------------------------------------
library(ggplot2)
# library(dendextend)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

# Theme setting (less is more)
theme_set(
  theme_classic()
)
# theme_update(
#   # legend.position = "top"
# )

gg <- ggplot(sil, aes(k, sil)) +
  xlab("k") +
  ylab("Silhueta média") +
  scale_y_continuous(breaks = seq(-.1, .5, .1)) +
  scale_x_continuous(breaks = 2:10) +
  scale_color_brewer(palette = ff.pal) +
  scale_fill_brewer(palette = ff.pal)

# plots -------------------------------------------------------------------

gg.hiper <- gg +
  # geom_hline(yintercept = c(0, .5), col = c(ff.col), lty = 2) +
  geom_hline(yintercept = unique(round(final_top$sil, 2)), col = "gray60", lty = 2, lwd = .1) +
  geom_jitter(aes(color = meth, shape = dist), width = .3, height = 0, alpha = .6)
