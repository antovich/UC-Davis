

## Function takes abbreivated state name and outcome name, returns name of hospital with lowest 30-day mortality for a specified outcome

best <- function(state, outcome) {
		data = read.csv("outcome-of-care-measures.csv")
		illnesses = c("heart attack", "pneumonia", "heart failure")
		
		## Produce error if incorrect outcome
		if (outcome %in% illnesses == FALSE) {
			stop("invalid outcome")
		}
		
		## Produce error if incorrect state
		if (state %in% data$State == FALSE) {
			stop("invalid state")
		}
		
		if (outcome == "heart attack") {
			data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)))
			
			## Logical of rows matching state from input
			currstate = data$State == state
			
			## Get lowest mortality value in state
			lowest = min(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack[currstate],
			na.rm = TRUE)
			
			## Logical of rows matching lowest mortality value in state 
			currmin = data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack == lowest
			
			## All matches for lowest mortality value in state
			matches = as.character(data$Hospital.Name[which(currmin & currstate)])
			min(matches)
		}
		
		else if (outcome == "pneumonia") {
			data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)))
			
			## Logical of rows matching state from input
			currstate = data$State == state
			
			## Get lowest mortality value in state
			lowest = min(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia[currstate],
			na.rm = TRUE)
			
			## Logical of rows matching lowest mortality value in state 
			currmin = data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia == lowest
			
			## All matches for lowest mortality value in state
			matches = as.character(data$Hospital.Name[which(currmin & currstate)])
			min(matches)			
		}
		
		else if (outcome == "heart failure") {
			data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)))
			
			## Logical of rows matching state from input
			currstate = data$State == state
			
			## Get lowest mortality value in state
			lowest = min(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure[currstate],
			na.rm = TRUE)
			
			## Logical of rows matching lowest mortality value in state 
			currmin = data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure == lowest
			
			## All matches for lowest mortality value in state
			matches = as.character(data$Hospital.Name[which(currmin & currstate)])
			min(matches)	
		}
}
		