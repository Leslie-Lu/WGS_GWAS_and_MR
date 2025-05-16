###############################################################################################
# PROJECT NAME      : src\wgs_gwas_and_mr\p011_GWAS_power.r
# DESCRIPTION       : Power analysis for GWAS
# DATE CREATED      : 2025-05-16
# OUTPUT            : output/Figure/F_001_GWAS_power.png
# R VERSION         : 4.5.0
# AUTHOR            : Zhen Lu
################################################################################################
# DATE MODIFIED     : 2025-05-16
# REASON            : Initial version
################################################################################################
rm(list = ls())
gc()

# lulab.utils::test_mirror("China")
# options(repos = c(CRAN = 'https://mirrors.zju.edu.cn/CRAN/'))
# install.packages("genpwr")
library(magrittr)
library(dplyr)
library(data.table)
library(purrr)
library(genpwr)
library(ggplot2)


test <- genpwr.calc(calc = "power", model = "logistic", ge.interaction = NULL,
                    N=c(198394 + 5578), Case.Rate=c(5578/(198394 + 5578)), k=NULL,
                    # N=c(4769 + 145545), Case.Rate=c(4769/(4769 + 145545)), k=NULL,
                    MAF=c(0.01, 0.02, 0.05, 0.10, 0.20, 0.50),
                    OR=seq(1.01, 2.00, 0.01), Alpha=5e-8,
                    True.Model=c("Additive"),
                    Test.Model=c("Additive"))

test$MAF %<>% factor(
  levels = c(0.01, 0.02, 0.05, 0.10, 0.20, 0.50),
  labels = c("MAF = 0.01", "MAF = 0.02", "MAF = 0.05", "MAF = 0.10", "MAF = 0.20", "MAF = 0.50")
)

# The minimum OR and MAF for power = 0.80
test %>%
  filter(`Power_at_Alpha_5e-08` >= 0.80) %>%
  arrange(OR, MAF) %>%
  head(1) %>%
  with(sprintf("The minimum OR for %s is %s", MAF, OR))
test %>%
  filter(`Power_at_Alpha_5e-08` >= 0.80) %>%
  arrange(MAF, OR) %>%
  head(1) %>%
  with(sprintf("The minimum MAF for OR = %s is %s", OR, MAF))

# gwas power plot
p= ggplot(test, aes(x=OR, y=`Power_at_Alpha_5e-08`)) +
  geom_line(aes(color=MAF), linewidth= 1.28) +
  expand_limits(x=c(1.00, 2.00), y=c(0, 1)) +
  scale_x_continuous(
    breaks = seq(1.00, 2.00, 0.20),
    labels = scales::label_number(accuracy = 0.01)
  ) +
  scale_y_continuous(
    breaks = seq(0, 1.00, 0.20),
    labels = function(x) if_else(x==0, "0", sprintf("%.2f", x))
  ) +
  labs(x="Odds Ratio (OR)", y="GWAS Statistical Power") +
  scale_color_discrete(
    name = "Minor Allele Frequency (MAF)", 
    guide = guide_legend(override.aes = list(linewidth = 2.8))
  ) +
  theme_classic() +
  geom_hline(yintercept = 0.80, linewidth=0.88, linetype = "dashed") +
  theme(
    text= element_text(size= 18),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(size= 15, colour = "black"),
    axis.text.y = element_text(size= 15, colour = "black"),
    legend.position = "inside",
    legend.position.inside = c(0.88, 0.4)
  )
p %>%
  ggsave(
    filename = "output/Figure/F_001_GWAS_power.png",
    width = 15, height = 9, dpi = 600
  )
