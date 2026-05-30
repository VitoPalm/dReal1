library(ggplot2)
library(tidyr)

ds = read.csv("Dataset_N7.csv", header=T)
attach(ds)

pivot_longer(
  cols = everything(),
 names_to = "variable",
  values_to = "value"
)

ggplot(df_long, aes(x = variable, y = value)) +
  geom_boxplot(width = 0.6, outlier.alpha = 0.6) +
  labs(
    title = "Boxplot of Variables",
    x = "Variable",
    y = "Value"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )