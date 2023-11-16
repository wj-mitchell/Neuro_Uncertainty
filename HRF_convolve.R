# HRF_convolve.R

HRF_convolve <- function(series = c(0,0,0.5,0,0,0,0,0,1,0,0,0,0,0,0.33,0,0,0,0,0,0,0), 
                         weights = c(0, 0.000354107958396228, 0.0220818694830938, 0.116001537001027,
                                     0.221299059999514, 0.242353095826523, 0.186831750619196, 0.113041009515928,
                                     0.0572809597709863, 0.0253492394574127, 0.0100814114758446, 0.00367740475539297,
                                     0.00124901102357508, 0.000399543113110135, 0),
                         trim){
  
  indices <- which(series != 0)
  values <- series[indices]
  convolution <- rep(0, length(series))
  
  for (INDEX in 1:length(indices)){
    
    weights_mod <- values[INDEX] * sum(weights)
    
    window <- indices[INDEX]:(indices[INDEX] + length(weights) - 1)
    
    if (max(window) > length(convolution)){
      window <- window[-(which(window > length(convolution)))]
    }
    
    for (TIMEPOINT in window){
      convolution[TIMEPOINT] <- convolution[TIMEPOINT] + (weights[which(window == TIMEPOINT)] * weights_mod)
    }
  }
  
  plot(convolution, type = "l")
  
  }
  