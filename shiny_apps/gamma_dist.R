library(shiny)
library(bslib)
library(ggplot2)

# Simple app to explore the distribution of ROS values drawn from a Gamma 
# distribution with specified mean and shape parameters. In particular, 
# we are interested in how likely it is to draw ROS values that exceed the
# maximum value for mean ROS that was used in the published JAGS model.
#
# Michael B
# 2025-08-11

ROS_MAX <- 15

ui <- page_sidebar(
  title = "Simulating ROS values from a Gamma distribution",
  sidebar = sidebar(
    sliderInput("mean", 
                "Mean ROS value:", 
                value = 5, 
                min = 1, 
                max = ROS_MAX, 
                step = 0.1,
                ticks = FALSE),
    
    sliderInput("shape", 
                "Gamma shape value:", 
                value = 1, 
                min = 1, 
                max = 50, 
                step = 0.1,
                ticks = FALSE)
  ),
  
  # Main panel with the density plot
  card(
    card_header("Distribution of ROS values simulated from Gamma distribution"),
    plotOutput("density_plot", height = "400px")
  ),
  
  # Additional card showing distribution statistics
  card(
    card_header("Distribution Statistics"),
    verbatimTextOutput("stats")
  )
)

server <- function(input, output, session) {
  
  # Reactive function to calculate rate parameter from mean and shape
  rate <- reactive({
    input$shape / input$mean
  })
  
  # Generate density plot
  output$density_plot <- renderPlot({
    # Calculate appropriate x range for plotting
    x_min <- 0
    x_max <- max(ROS_MAX + 1, qgamma(0.99, input$shape, rate()))
    
    # Generate x values for density curve
    x_vals <- seq(x_min, x_max, length.out = 1000)
    
    # Calculate density values
    density_vals <- dgamma(x_vals, shape = input$shape, rate = rate())
    
    # Create data frame for ggplot
    plot_data <- data.frame(x = x_vals, density = density_vals)
    
    # Create the plot
    ggplot(plot_data, aes(x = x, y = density)) +
      geom_vline(xintercept = ROS_MAX, colour = "darkred", linewidth = 1) +
      annotate("text", x = ROS_MAX, y = max(density_vals) * 0.8,
               label = "Max mean ROS",
               hjust = -0.1, colour = "darkred") +
      
      geom_line(colour = "steelblue", size = 1.2) +
      
      geom_area(alpha = 0.3, fill = "steelblue") +
      
      geom_vline(xintercept = input$mean, colour = "darkblue", linetype = "dashed", linewidth = 1) +
      
      annotate("text", x = input$mean, y = max(density_vals) * 0.9, 
               label = paste("Mean =", round(input$mean, 2)), 
               hjust = -0.1, colour = "darkblue") +
      
      labs(x = "Value",
           y = "Density") +
      
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  # Display distribution statistics
  output$stats <- renderText({
    # Calculate statistics
    mode_val <- ifelse(input$shape > 1, (input$shape - 1) / rate(), 0)
    range_90 <- qgamma(c(0.05, 0.95), input$shape, input$mean / input$mean)
    prob_exceed <- 1.0 - pgamma(ROS_MAX, input$shape, rate())

    paste0("Mean: ", round(input$mean, 3), "\n",
           "Mode: ", round(mode_val, 3), "\n",
           "Central 90% interval: [", round(range_90[1], 3), ", ", round(range_90[2], 3), "] \n",
           "Probability of exceeding upper ROS value (15.0): ", round(100 * prob_exceed, 3), "%" )
  })
}

shinyApp(ui = ui, server = server)
