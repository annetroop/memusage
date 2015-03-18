shinyServer(
  function(input,output) {

      library(plyr)
      library(lubridate)
      library(ggplot2)
      
      dir <- "./"

      listdf <- rep(NULL, 4)
      filename <- rep(NULL, 4)
      for (i in c(1:4)) {
        filename[i] <- paste(dir, "/machine",i,"_memusage.out", sep="");
        listdf[[i]] <- read.table(filename[i])
        listdf[[i]]$machine <- paste("machine",i,sep="");
      }

      # find out which machines were selected to compare       
      output$oid2 <- renderText(input$id2) 
      output$distPlot <- renderPlot ({
          # rbind together the datafames for all the selected machines
          first <- strtoi(input$id2[1])
          mem <- listdf[[first]]
          vertical = input$flip
          for (istr in input$id2 ) {
              i <- strtoi(istr)
              if (i != first) {
                mem <- rbind(mem, listdf[[i]])
              }
          }
          
        # make a single timestamp field
        mem$when <- ymd_hms(paste(mem$V1, mem$V2))
        
        mem <- transform(mem, machine = factor(machine))     
        mem_subset <- subset(mem, ( (mem$when > ymd(input$begin))  & ( mem$when <= ymd(input$end) )   )  )
        g <- ggplot(mem, aes(when, V3) ) 
        g <- g + geom_point(aes(color = machine))
        g <- g + ylab("kb RAM used")
        g <- g + labs(title = "memory usage over time")
        vertical = input$flip
        if (vertical) {
          g <- g + facet_grid( . ~ machine)
        } else {
          g <- g + facet_grid( machine ~ .)
        }
        plot(g)
        
     }
    )
   }
  )