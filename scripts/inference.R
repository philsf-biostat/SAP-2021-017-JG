# setup -------------------------------------------------------------------

# tables ------------------------------------------------------------------

sil %>%
  slice_max(sil, n = 10)

sil %>%
  filter(!(meth %in% c("centroid", "median")) ) %>%
  slice_max(sil, n = 10)

# analytical %>%
#   filter(cluster == 2) %>%
#   select(id, cluster) %>%
#   inner_join(deputados, by = "id") %>%
#   select(-id)
