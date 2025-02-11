# setup -------------------------------------------------------------------
suppressPackageStartupMessages(library(tidyverse))
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
data.raw <- read_csv("dataset/eleitos_2018.csv", show_col_types = FALSE) %>%
  janitor::clean_names()

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  # apenas os evangélicos
    filter(evangelico == 1) %>%
  select(
    # não precisamos mais desta variável
    -evangelico,
  )

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    id = as.character(id),
    primeira = factor(primeira, labels = c("Primeiro mandato", "Reeleito")),
    sexo = factor(sexo, labels = c("Masculino", "Feminino")),
    # evangelico = factor(evangelico, labels = c("Outros", "Evangélico")),
    igreja = fct_rev(fct_infreq(igreja)),
    total_receita = total_receita/1000000,
    num_votos = num_votos/1000000,
    filiados = filiados/1000000,
    receita_agp = receita_agp/1000000,
    receita_agr = receita_agr/1000000,
    receita_com = receita_com/1000000,
    receita_fin = receita_fin/1000000,
    receita_inf = receita_inf/1000000,
    receita_ind = receita_ind/1000000,
    receita_pf = receita_pf/1000000,
    receita_rp = receita_rp/1000000,
    receita_ser = receita_ser/1000000,
    # capilaridade = capilaridade*10,
  ) %>%
  mutate(
    # usar apenas agp e outras
    receita_outras = total_receita - receita_agp,
  )

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    partido = "Partido",
    uf = "UF",
    capilaridade = "Capilaridade",
    primeira = "Releição vs primeiro mandato",
    sexo = "Sexo",
    # evangelico = "Evangélico",
    num_votos = "Votos (milhão)",
    decil_filiados = "Decil do núm. de filiados",
    decil_deputados = "Decil do núm. de deputados",
    total_receita = "Receita total (milhão R$)",
    posicao = "Índice de Power e Silveira-Rodrigues",
    igreja = "Nome da Igreja",
    receita_agp = "Receita AGP (milhão R$)",
    receita_outras = "Outras receitas (milhão R$)",
    corp_pentecostal = "Corporação Pentecostal",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw %>%
  # select analytic variables
  select(
    id,
    corp_pentecostal,
    receita_agp,
    receita_outras,
    num_votos,
    capilaridade,
    posicao,
    decil_filiados,
    decil_deputados,
  )

deputados <- data.raw %>%
  select(id, nome, sexo, partido, uf, posicao, igreja, corp_pentecostal)

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( "1", "2", "3", "...", as.character(nrow(analytical)) ) ) %>%
  left_join(analytical %>% head(0), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
