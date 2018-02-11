
## Function takes abbreivated state name and outcome name, returns name of hospital with lowest 30-day mortality for a specified outcome

rankhospital <- function(state, outcome, num) {
		data = read.csv("outcome-of-care-measures.csv")
		illnesses = c("heart attack", "pneumonia", "heart failure")
		rank = c("best", "worst")
		currstate = data$State == state
		
		## Produce error if incorrect outcome
		if (outcome %in% illnesses == FALSE) {
			stop("invalid outcome")
		}
		
		## Produce error if incorrect state
		if (state %in% data$State == FALSE) {
			stop("invalid state")
		}
		
		## Produce error if incorrect num
		if (num %in% rank == FALSE) {
			if (is.numeric(num) == FALSE) {
			stop("invalid num")
			}
		}
		
		if (outcome == "heart attack") {
			
			data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)))
			
			withdata = is.na(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack[currstate]) == FALSE
			
			ranking = data$Hospital.Name[currstate][withdata][order(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack[currstate][withdata], data$Hospital.Name[currstate][withdata])]
			
			if (num == "best") {
				as.character(ranking[1])
			}
			else if (num == "worst") {
				as.character(ranking[length(ranking)])
			}
			
			else as.character(ranking[num])
			
		}
				
		else if (outcome == "pneumonia") {
			data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)))
			
			withdata = is.na(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia[currstate]) == FALSE
			
			ranking = data$Hospital.Name[currstate][withdata][order(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia[currstate][withdata], data$Hospital.Name[currstate][withdata])]
			
			if (num == "best") {
				as.character(ranking[1])
			}
			else if (num == "worst") {
				as.character(ranking[length(ranking)])
			}
			
			else as.character(ranking[num])
		}
		
		else if (outcome == "heart failure") {
			data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)))
			
			withdata = is.na(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure[currstate]) == FALSE
			
			ranking = data$Hospital.Name[currstate][withdata][order(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure[currstate][withdata], data$Hospital.Name[currstate][withdata])]
			
			if (num == "best") {
				as.character(ranking[1])
			}
			else if (num == "worst") {
				as.character(ranking[length(ranking)])
			}
			
			else as.character(ranking[num])
		}
}
