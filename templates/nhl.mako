${main()}

<%def name="main()">
    ${top_base(rounds)}

    <div class="col-md-12">
        ${dump_rounds(rounds)}
        ${dump_score_summary(score_summary)}
    </div>

    ${bottom_base()}
</%def>

<%def name="top_base(rounds)">
    <html>
    <head>
        <link rel="stylesheet" type="text/css" href="static/nhl.css">
        <title>Playoff Predictions</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    </head>
    <body>

    ${navbar_render(rounds)}

    <div class="container">
        <div class="jumbotron">
        <h2>Pedle's Family Playoff Predictions</h2>
        <p>Every year my wife & I make our NHL playoff predictions.  This year my 4 year old daughter joined in on the fun.  Below is the results</p>
        </div>
        <div class="row">
</%def>


<%def name="navbar_render(rounds)">
    <nav class="navbar navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>                        
          </button>
          <a class="navbar-brand" href="#">PlayoffPreds</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
          <ul class="nav navbar-nav">
            <li class="active"><a href="#">Home</a></li>
            %for round in rounds:
                <li><a href="#round${round.number}">Round ${round.number}</a></li>
            %endfor
            <li><a href="#totals">Totals</a></li>
          </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="https://github.com/pzelnip/playoffpreds">
                <span class="glyphicon glyphicon-cutlery">
                </span> Fork Me On Github
                    </a></li>
          </ul>
        </div>
      </div>
    </nav>

</%def>

<%def name="bottom_base()">
        </div> <!-- class="row"> -->
        <br><br><br><br><br><br>
        <div class="centerblock smalltext">
        <a href="http://www.sportsnet.ca/hockey/nhl/playoffs/">Sportsnet.ca NHL Playoffs</a>
         - 
        <a href="static/playoffs.json">View JSON</a>

    </div> <!-- container -->

    </body>
    </html>
</%def>

<%def name="dump_score_summary(score_summary)">
    <br><br><br>

    <a name="totals"></a>
    <div class="scoreSummary">
        <span class="totalsHeading">Totals</span>

        %for round_score in score_summary.round_scores:
            ${dump_round_score(round_score)}
        %endfor

        <h2 class="text-center">Final Totals</h2>
        %for player_score in score_summary.final_score.scores:
            ${dump_prediction_score(player_score.name,
                player_score.score, 
                score_summary.final_score.possible,
                player_score.percent)}
        %endfor
    </div>
</%def>

<%def name="dump_round_score(round_score)">
    <h3 class="centertext">Round ${round_score.round_num}</h3>
    %for player_score in round_score.scores:
            ${dump_prediction_score(player_score.name, 
                player_score.score, round_score.possible, 
                player_score.percent)}
    %endfor
</%def>

<%def name="dump_prediction_score(name, score, possible, percent)">
    <div class="predictionScore">
        ${name} ${score} points (out of ${possible} possible, ${"%.0f" % percent}%)
    </div>
</%def>

<%def name="dump_rounds(rounds)">
    %for round in rounds:
        ${dump_round(round)}
    %endfor
</%def>

<%def name="dump_round(round)">
    <a name="round${round.number}">
    <h2 class="roundTitle">Round ${round.number}</h2>
    </a>

    %for matchup in round.matchups:
        ${dump_matchup(matchup)}
    %endfor
</%def>

<%def name="dump_matchup(matchup)">
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

        <div class="predictionList">
            %for prediction in matchup.predictions:
                ${dump_prediction(prediction)}
            %endfor
        </div>
    </div>
    <br> <br> <br> <br> <br> <br>
</%def>

<%def name="dump_prediction(prediction)">
    <div class="prediction">
        ${prediction.predictor} says ${prediction.team} in ${prediction.games}
    </div>
    <div class="predictionResult">
        ${prediction.outcome}
    </div>
</%def>
