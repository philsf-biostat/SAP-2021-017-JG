# setup -------------------------------------------------------------------
library(ggplot2)
# library(dendextend) %>% suppressPackageStartupMessages()

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "RdYlBu"    # good for binary groups scale fill/color brewer

# Theme setting (less is more)
theme_set(
  theme_classic()
)
# theme_update(
#   # legend.position = "top"
# )

gg <- sil %>%
  mutate(
    # reordenar distâncias de acordo com os shapes da paleta
    dist = fct_relevel(dist, c(
      "minkowski_0.5",
      "euclidian",
      "maximum",
      "minkowski_1.5",
      "canberra",
      "manhattan"
    )),
    # reordenar métodos de acordo com as cores da paleta
    meth = fct_relevel(meth, c(
      "single",
      "complete",
      "median",
      "centroid",
      "average",
      "ward.D",
      "ward.D2"
    )),
  ) %>%
  ggplot(aes(y = sil)) +
  ylab(attr(sil$sil, "label")) +
  labs(color = "Ligação", shape = "Métrica") +
  scale_y_continuous(breaks = seq(-.1, .5, .1)) +
  scale_color_brewer(palette = ff.pal) +
  scale_fill_brewer(palette = ff.pal)

# plots -------------------------------------------------------------------

gg.hiper <- gg +
  scale_x_continuous(breaks = 2:10) +
  xlab(attr(sil$k, "label")) +
  geom_hline(yintercept = unique(round(final_top$sil, 2)), col = "gray60", lty = 2, lwd = .1) +
  geom_jitter(aes(k, color = meth, shape = dist), width = .25, height = 0)

gg.k <- gg +
  scale_x_continuous(breaks = 2:10) +
  xlab(attr(sil$k, "label")) +
  geom_boxplot(aes(k, group = k), fill = ff.col)

gg.m <- gg +
  xlab(attr(sil$meth, "label")) +
  geom_boxplot(aes(meth), fill = ff.col)

gg.d <- gg +
  xlab(attr(sil$dist, "label")) +
  geom_boxplot(aes(dist), fill = ff.col)
