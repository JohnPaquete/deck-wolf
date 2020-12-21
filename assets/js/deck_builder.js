$(function () {
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
});