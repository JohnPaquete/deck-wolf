$('a[rel=popover]').popover({
    trigger: 'hover',
    animation: true,
    placement: 'right',
    html: true,
    content: function(){ return '<img class=\"w-100 card-rounded\" src=\"' + $(this).data('img') + '\">' }
});