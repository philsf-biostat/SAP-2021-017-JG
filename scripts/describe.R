# setup -------------------------------------------------------------------

library(gtsummary) %>% suppressPackageStartupMessages()
library(gt)

# setup gtsummary theme
theme_gtsummary_mean_sd() # mean/sd
theme_gtsummary_language(language = "pt") %>% suppressMessages() # traduzir

# exploratory -------------------------------------------------------------

# overall description
# analytical %>%
#   skimr::skim()

# tables ------------------------------------------------------------------

# tab_desc <- analytical %>%
#   # select
#   select(
#     -id,
#   ) %>%
#   tbl_summary(
#     by = corp_pentecostal,
#     type = list(
#       decil_filiados ~ "continuous",
#       decil_deputados ~ "continuous"
#     ),
#   ) %>%
#   # modify_caption(caption = "**Tabela 1** Características demográficas") %>%
#   # modify_header(label ~ "**Características dos pacientes**") %>%
#   bold_labels() %>%
#   modify_table_styling(columns = "label", align = "c")

