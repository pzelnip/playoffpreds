${main()}


<%def name="main()">
	${top_base()}
	${dump_rounds(rounds)}
	${dump_score_summary(score_summary)}
	${bottom_base()}
</%def>



<%def name="top_base()">
	<html>
	<head>
		<link rel="stylesheet" type="text/css" href="static/nhl.css">
		<title>Playoff Predictions</title>
	</head>
	<body>
</%def>


<%def name="bottom_base()">
	<br><br><br><br><br><br>
	<div class="centerblock smalltext">
	<a href="http://www.sportsnet.ca/hockey/nhl/playoffs/">Sportsnet.ca NHL Playoffs</a>
	 - 
	<a href="static/playoffs.json">View JSON</a>

	<a href="https://github.com/pzelnip/playoffpreds"><img style="position: absolute; top: 0; right: 0; border: 0;" 
	    src="https://camo.githubusercontent.com/e7bbb0521b397edbd5fe43e7f760759336b5e05f/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67" 
	    alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png"></a>
	</body>
	</html>
</%def>

<%def name="dump_score_summary(score_summary)">
	<br><br><br>

	<div class="scoreSummary">
		<span class="totalsHeading">Totals</span>

		MORE STUFF HERE
	</div>
</%def>

<%def name="dump_rounds(rounds)">
	%for round in rounds:
		<h2 class="roundTitle">Round ${round.number}</h2>

		${dump_matchups(round.matchups)}
	%endfor
</%def>

<%def name="dump_matchups(matchups)">
	%for matchup in matchups:
    <div class="matchup">
    	<div class="teamNames">
    		<div class="team hometeam">
            ${matchup.home}<br>
            <img src="${matchup.homeimg}" class="teamLogo">
    		</div>
    		<div class="vsCenter">
    		Vs
    		</div>
    		<div class="team awayteam">
    			${matchup.away}<br>
                <img src="${matchup.awayimg}" class="teamLogo">
    		</div>
    	</div>
    	<div class="result">${matchup.result}</div>

    	${dump_predictions(matchup.predictions)}
    </div>
    <br> <br> <br> <br> <br> <br>


	%endfor
</%def>

<%def name="dump_predictions(predictions)">
	<div class="predictionList">
		%for prediction in predictions:
			<div class="prediction">
			${prediction.predictor} says ${prediction.team} in ${prediction.games}
	        </div>
			<div class="predictionResult">
				${prediction.outcome}
			</div>
		%endfor
	</div>
</%def>
