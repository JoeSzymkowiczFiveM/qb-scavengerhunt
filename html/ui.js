ScavengerHunt = {}

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var eventData = event.data;

        if (eventData.action == "openList") {
            $('.scavenger-hunt').fadeIn(150);
            ScavengerHunt.GenerateList(eventData)
        }
    });
});

$(document).on('keydown', function() {
    switch (event.keyCode) {
        case 27:
            $('.scavenger-hunt').fadeOut(100);
            $.post('https://qb-scavengerhunt/close');
            break;
    }
});

ScavengerHunt.GenerateList = function(data) {
    //console.log(data)
    $.each(data.clues, function(i, clue) {
        if (clue.completed) {
            $("#clue_"+i).html(i+1 + " - " + clue.clue.strike());
        } else {
            $("#clue_"+i).html(i+1 + " - " + clue.clue);
        }
    });
}