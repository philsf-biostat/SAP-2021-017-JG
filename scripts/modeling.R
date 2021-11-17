# setup -------------------------------------------------------------------
library(cluster)

dists <- c(
  "euclidian",
  "maximum",
  "manhattan",
  "canberra",
  "minkowski_0.5",
  "minkowski_1.5"
)

meths <- c(
  "complete",
  "single",
  "average",
  "ward.D",
  "ward.D2",
  "median",
  "centroid"
)

spit_dist <- function(data = analytical, dist) {
  p <- 2
  if(dist == "minkowski_0.5") {
    dist <- "minkowski"
    p <- 0.5
  }
  if(dist == "minkowski_1.5") {
    dist <- "minkowski"
    p <- 1.5
  }
  
  # retorna a matriz de distâncias
  dist(data[, -c(1:2)], method = dist, p = p)
}

spit_hc <- function(data = analytical, dist, method) {
  dm <- spit_dist(data = data, dist = dist)
  
  # retorna o HC
  hclust(dm, method = method)
}

spit_sil <- function(data = analytical, k, dist, method) {
  dm <- spit_dist(data = data, dist = dist)

  hclust(dm, method = method) %>%
    cutree(k = k) %>%
    # retorna a silhueta
    silhouette(dist = dm)
}

# espaço de hiperparâmetros -----------------------------------------------

# library(foreach)
# 
# sil <- foreach(d = dists, .combine = rbind) %:%
#   foreach(k = 2:10, .combine = rbind) %:%
#   foreach(m = meths, .combine = rbind) %do% {
# 
#     # coletar a silhueta média
#     s <- spit_sil(k = k, dist = d, method = m) %>%
#       summary()
#     s <- s$si.summary["Mean"] %>%
#       as.numeric()
# 
#     # retorna data frame
#     tibble(
#       k = k,
#       dist = d,
#       meth = m,
#       sil = s
#       )
#   }
# 
# write_csv(sil, "figures/sil.csv")

# cluster hierárquico -----------------------------------------------------

sil <- read_csv("figures/sil.csv")

# top 10 silhuetas
final_top <- sil %>%
  # filter(!(meth %in% c("centroid", "median")) ) %>%
  slice_max(sil, n = 10)

# resultado rejeitado
s.rej <- spit_sil(k = final_top[1, 1], dist = final_top[1, 2], method = final_top[1, 3])

# linha a ser usada (top3)
final_row <- 5

final_k <- final_top[final_row, 1]
final_d <- final_top[final_row, 2]
final_m <- final_top[final_row, 3]

# dm <- spit_dist(dist = final_d)
# hc <- dm %>%
#   hclust(method = final_m)
# analytical$cluster <- hc %>%
#   cutree(k = final_k)

s <- spit_sil(k = final_k, dist = final_d, method = final_m)

# diagnosticos ------------------------------------------------------------

# resultado final
# s <- analytical$cluster %>% silhouette( dist = dm)
s %>% summary()

# resultado rejeitado
s.rej %>% summary()
