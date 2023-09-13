## Tracey Mangin
## September 11, 2023
## figures for presentations

## libraries
library(here)
library(sf)
library(viridis)
library(tigris)
library(stagg)


## coounty polgyons
ca_counties <- counties("CA") %>%
  st_as_sf()


ca_counties_fig <- ggplot() + 
  geom_sf(data = ca_counties, fill = "white", color = "black", size = 2) +
  # theme_bw() +
  theme_minimal() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.line = element_blank(),
        axis.title.x = element_text(size = axis_text_size),
        axis.title.y = element_text(size = axis_text_size),
        plot.background = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        )

ggsave(ca_counties_fig,
       filename = here("figs/presentation/ca_counties.png"),
       width = 3,
       height = 4,
       units = "in",
       dpi = 300)

## cropland plot
cropland_fig <- ggplot(cropland_world_2015_era5, aes(x = x, y = y, fill = weight, color = weight)) +
  geom_tile() +
  theme_minimal() +
  # xlim(c(-180, 0)) +
  ylim(c(0, 90)) +
  scale_fill_viridis(option = "mako"
                     # , 
                     # direction = -1
                     ) +
  scale_color_viridis(option = "mako"
                     # , 
                     # direction = -1
  ) +
  # guides()
  theme_minimal() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        # axis.title.x = element_text(size = axis_text_size),
        # axis.title.y = element_text(size = axis_text_size),
        plot.background = element_blank(),
        legend.position = "right",
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 13),
        panel.background = element_blank(),
        panel.border = element_blank(), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
  )

ggsave(cropland_fig + theme(legend.position = "none"),
       filename = here("figs/presentation/cropland.png"),
       width = 4,
       height = 2,
       units = "in",
       dpi = 300)

cropland_legend <- get_legend(cropland_fig)

ggsave(cropland_legend,
       filename = here("figs/presentation/cropland_l.png"),
       # width = 3,
       # height = 2,
       # units = "in",
       dpi = 300)

