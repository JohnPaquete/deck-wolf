$(function () {
    //Gets the list of potential card names for card input fields
    var autocompleteOptions = {
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                type: "POST",
                url: "/api/card_autocomplete/",
                dataType: 'json',
                contentType: 'application/json',
                data: JSON.stringify({
                    term: request.term
                }),
                success: function (res) {
                    response(res.data);
                }
            });
        }
    };
    $("input.card-autocomplete").autocomplete(autocompleteOptions);

    //Shows or hides the commander inputs on change of format
    $("#format").change(function(){
        var val = $(this).val()
        console.log(val)
        if (val === "commander")
        {
            $(".commander-row").collapse("show")
            
        }
        else
        {
            $(".commander-row").collapse("hide")
        }
        
    });

    //clears the values for the commander inputs when the are hidden
    $(".commander-row").on("hidden.bs.collapse", function(){
        $(".commander-row input").val('')
    });

    $(".deck-add").click(function(){
        var target = $(this).data("target")
        var quantity = $(target + "-quantity").val()
        var card = $(target + "-search").val()
        var deck = $(target)
        if (card !== '')
        {
            deck.val(deck.val() + quantity + ' ' + card + '\n')
        }
    });
});