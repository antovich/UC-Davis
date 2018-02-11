## Function takes outcome name (outcome) and ranking number (num), returns name of hospital from each state with "num" ranking for 30-day mortality for a specified outcome. Returns NA if not enough hospitals to meet ranking for given state. "Num" can be numeric or "best" or "worst", default is "best".

rankall <- function(outcome, num = "best") {
		data = read.csv("outcome-of-care-measures.csv")
		illnesses = c("heart attack", "pneumonia", "heart failure")
		rank = c("best", "worst")

		## Produce error if incorrect outcome
		if (outcome %in% illnesses == FALSE) {
			stop("invalid outcome")
		}
		
		## Produce error if incorrect num
		if (num %in% rank == FALSE) {
			if (is.numeric(num) == FALSE) {
			stop("invalid num")
			}
		}

		allstates = levels(data$State)
		nstates = length(allstates)
		hospital = c()
		state = c()


		if (outcome == "heart attack") {
			a = 1
			data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack)))
			
			for (istate in 1:nstates) {
				currstate = data$State == allstates[istate]
				withdata = is.na(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack[currstate]) == FALSE
				ranking = data$Hospital.Name[currstate][withdata][order(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack[currstate][withdata], data$Hospital.Name[currstate][withdata])]
			
				if (num == "best") {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[1])
					a = a + 1
				}
				else if (num == "worst") {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[length(ranking)])
					a = a + 1
				}
				else if (length(ranking) < num) {
					state[a] = allstates[istate]
					hospital[a] = NA
					a = a + 1
				}	
				else {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[num])
					a = a + 1
				}			
			}
			data.frame(hospital, state, row.names = allstates)
		}
				
		else if (outcome == "pneumonia") {
			a = 1
			data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia)))
			
			for (istate in 1:nstates) {
				currstate = data$State == allstates[istate]
				withdata = is.na(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia[currstate]) == FALSE
				ranking = data$Hospital.Name[currstate][withdata][order(data$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia[currstate][withdata], data$Hospital.Name[currstate][withdata])]
			
				if (num == "best") {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[1])
					a = a + 1
				}
				else if (num == "worst") {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[length(ranking)])
					a = a + 1
				}
				else if (length(ranking) < num) {
					state[a] = allstates[istate]
					hospital[a] = NA
					a = a + 1
				}	
				else {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[num])
					a = a + 1
				}			
			}
			data.frame(hospital, state, row.names = allstates)
		}
		
		else if (outcome == "heart failure") {
			a = 1
			data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure =
			suppressWarnings(as.numeric(as.character
			(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure)))
			
			for (istate in 1:nstates) {
				currstate = data$State == allstates[istate]
				withdata = is.na(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure[currstate]) == FALSE
				ranking = data$Hospital.Name[currstate][withdata][order(data$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure[currstate][withdata], data$Hospital.Name[currstate][withdata])]
			
				if (num == "best") {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[1])
					a = a + 1
				}
				else if (num == "worst") {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[length(ranking)])
					a = a + 1
				}
				else if (length(ranking) < num) {
					state[a] = allstates[istate]
					hospital[a] = NA
					a = a + 1
				}	
				else {
					state[a] = allstates[istate]
					hospital[a] = as.character(ranking[num])
					a = a + 1
				}			
			}
			data.frame(hospital, state, row.names = allstates)
		}
}