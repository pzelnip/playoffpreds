${main()}

<%def name="main()">
    <html>
    ${head_element()}
    <body>

    ${top_base(rounds)}
    ${dump_rounds(rounds)}
    ${dump_score_summary(score_summary)}
    ${bottom_base()}

    </body>
    </html>
</%def>

<%def name="head_element()">
    <head>
        <link rel="stylesheet" type="text/css" href="static/nhl.css">
        <title>Playoff Predictions</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    </head>
</%def>

<%def name="top_base(rounds)">

    ${navbar_render(rounds)}

    <div class="container">
        <div class="jumbotron">
            <h2>Pedle's Family Playoff Predictions</h2>
            <p>Every year my wife & I make our NHL playoff predictions.  This year my 4 year old daughter joined in on the fun.  Below is the results</p>
        </div>
    </div>
</%def>


<%def name="navbar_render(rounds)">
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>                        
                </button>
                <a class="navbar-brand" href="#">PlayoffPreds</a>
            </div>
            <div>
                <div class="collapse navbar-collapse" id="myNavbar">
                    <ul class="nav navbar-nav">
                        %for round in rounds:
                            <li><a href="#round${round.number}">Round ${round.number}</a></li>
                        %endfor
                        <li><a href="#totals">Totals</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li>
                            <a href="https://github.com/pzelnip/playoffpreds">
                                <span class="glyphicon glyphicon-cutlery"></span>
                                Fork Me On Github
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
</%def>

<%def name="bottom_base()">
    <br><br><br><br><br><br>
    <div class="text-center smalltext text-muted">
        <a href="http://www.sportsnet.ca/hockey/nhl/playoffs/">Sportsnet.ca NHL Playoffs</a>
         - 
        <a href="static/playoffs.json">View JSON</a>
    </div>
</%def>

<%def name="dump_score_summary(score_summary)">
    <br><br><br>

    <div id="totals">
        <div class="scoreSummary text-center">
            <h3 class="totalsHeading text-center">Totals</h3>

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
    </div>
</%def>

<%def name="dump_round_score(round_score)">
    <h3 class="text-center">Round ${round_score.round_num}</h3>
    %for player_score in round_score.scores:
            ${dump_prediction_score(player_score.name, 
                player_score.score, round_score.possible, 
                player_score.percent)}
    %endfor
</%def>

<%def name="dump_prediction_score(name, score, possible, percent)">
    <div class="predictionScore">
        ${name} ${score} points (out of ${possible} possible)
        <div class="progress" style="width:50%; margin: 0 auto;">
            <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100" style="width:${percent}%">
                ${"%.0f" % percent}%
            </div>
        </div>

    </div>
</%def>

<%def name="dump_rounds(rounds)">
    %for round in rounds:
        ${dump_round(round)}
    %endfor
</%def>

<%def name="dump_round(round)">
    <div id="round${round.number}" class="round-container">
        <div class="container">
            <div class="row">
                <h2 class="roundTitle text-center">Round ${round.number}</h2>
                </a>
            </div>

            <div class="panel-group">
                %for matchup in round.matchups:
                    ${dump_matchup(matchup)}
                %endfor
            </div>
        </div> <!-- container -->
    </div> <!-- id=round... -->
</%def>

<%def name="dump_matchup(matchup)">
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="row">
                <div class="col-md-1">&nbsp;</div>

                <div class="col-md-4">
                    <div class="pull-left hometeam teamNames">
                        ${matchup.home}<br>
                        <img src="${matchup.homeimg}" class="teamLogo img-responsive hometeamimg">
                    </div>
                </div>
                <div class="col-md-2 text-center lead">
                    Vs
                </div>
                <div class="col-md-4 teamNames">
                    <div class="awayteam pull-right">
                        ${matchup.away}<br>
                        <img src="${matchup.awayimg}" class="teamLogo img-responsive awayteamimg">
                    </div>
                </div>
                <div class="col-md-1">&nbsp;</div>
            </div>
            <div class="row text-center result">
                ${matchup.result}
            </div>
            <div class="row">
                %for prediction in matchup.predictions:
                    ${dump_prediction(prediction)}
                %endfor
            </div>
        </div>
    </div>
</%def>

<%def name="dump_prediction(prediction)">
    <div class="container">
        <div class="col-md-2"> </div>
        <div class="col-md-4 text-right">
            ${prediction.predictor} says ${prediction.team} in ${prediction.games}
        </div>
        <div class="col-md-4 text-left">
            ${prediction.outcome}
        </div>
        <div class="col-md-2"> </div>
    </div>
</%def>
