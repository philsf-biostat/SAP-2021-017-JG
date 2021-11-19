# setup -------------------------------------------------------------------
library(cluster)

ks <- 2:10

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

## funções de suporte: argumento data deve conter apenas variáveis contínuas

spit_dist <- function(data = analytical[, -c(1:2)], dist) {
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
  dist(data, method = dist, p = p)
}

spit_hc <- function(data = analytical[, -c(1:2)], dist, method) {
  dm <- spit_dist(data = data, dist = dist)
  
  # retorna o HC
  hclust(dm, method = method)
}

spit_sil <- function(data = analytical[, -c(1:2)], k, dist, method) {
  dm <- spit_dist(data = data, dist = dist)

  hclust(dm, method = method) %>%
    cutree(k = k) %>%
    # retorna a silhueta
    silhouette(dist = dm)
}

# espaço de hiperparâmetros -----------------------------------------------

# library(foreach) %>% suppressPackageStartupMessages()
# 
# sil <- foreach(d = dists, .combine = rbind) %:%
#   foreach(k = ks, .combine = rbind) %:%
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
# # ordenar sil decrescente
# sil <- sil %>%
#   arrange( desc(sil) )
# 
# write_csv(sil, "figures/sil.csv")

# cluster hierárquico -----------------------------------------------------

sil <- read_csv("figures/sil.csv", show_col_types = FALSE)

sil <- sil %>%
  set_variable_labels(
    k = "k",
    dist = "Métrica (distância)",
    meth = "Método de ligação",
    sil = "Silhueta média",
  )

# top 10 silhuetas (usadas também no plot)
final_top <- sil %>%
  # filter(!(meth %in% c("centroid", "median")) ) %>%
  slice_max(sil, n = 10)

# resultado rejeitado
final_sil.rej <- spit_sil(k = sil[1, 1], dist = sil[1, 2], method = sil[1, 3])

# linha a ser usada (top3)
final_row <- 5

final_k <- sil[final_row, 1]
final_d <- sil[final_row, 2]
final_m <- sil[final_row, 3]

# salvar cluster no data frame identificado
final_hc <- spit_hc(dist = final_d, method = final_m)
deputados$cluster <- final_hc %>% cutree(k = final_k)

final_sil <- spit_sil(k = final_k, dist = final_d, method = final_m)

# diagnosticos ------------------------------------------------------------

# resultado final
s <- final_sil %>% summary()

# resultado rejeitado
s.rej <- final_sil.rej %>% summary()
