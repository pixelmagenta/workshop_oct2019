library("jsonlite")
library("igraph")
library("httr")

metadata <- GET("https://dracor.org/api/corpora/span/metadata", accept("text/csv"))
metadata_csv <- content(GET("https://dracor.org/api/corpora/rus/metadata", accept("text/csv")), as = "parsed")

play_csv <- read.csv("https://dracor.org/api/corpora/rus/play/griboyedov-gore-ot-uma/networkdata/csv", stringsAsFactors = F)
play_csv$Type <- NULL
play_graph <- graph_from_data_frame(play_csv, directed = F)
play_graph <- set_edge_attr(play_graph, "weight", value = play_csv$Weight)

plot(play_graph)
#graphlets <- graphlet_basis(play_graph)

l <- layout_with_dh(play_graph)


V(g)$color <- plot_colors
V(g)$frame.color <- plot_colors

V(play_graph)$label.color <- "black"
V(play_graph)$label.cex <- 1.3
V(play_graph)$label.degree <- -pi/2
plot(play_graph, vertex.label.dist = 1.3, vertex.size = 9, layout = layout_on_sphere(play_graph))

V(play_graph)$closeness <- closeness(play_graph, weights = NA)
V(play_graph)$degree <- degree(play_graph)
play_data <- as_data_frame(play_graph, what = "vertices")

ev <- data.frame(as.list(eigen_centrality(play_graph, weights = NA)$vector))

list_of_names <- fromJSON("https://dracor.org/api/corpora/rus")

sorted_names <- list_of_names$dramas$name[sort.list(list_of_names$dramas$name)]

plays <- lapply(sorted_names, function(x) read.csv(paste0("https://dracor.org/api/corpora/rus/play/", x, "/networkdata/csv"), stringsAsFactors = F))

