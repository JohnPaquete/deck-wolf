
$('#advanced-search').submit(function(event) {
    var form = $(this);

    form.find('.check-group').filter(function() {
        return $(this).find('input[name]').filter(function() {return $(this).is(':checked');}).length === 0;
    }).find('select').remove();

    form.find('.select-group').filter(function() {
        return $(this).find('input[name]').filter(function() {return $(this).val() !== '';}).length === 0;
    }).find('select').remove();

    form.find('.total-group').filter(function() {
        return $(this).find(':input[name]').filter(function() {return $(this).val() === '';}).length > 0;
    }).find('select').remove();

    form.find(':input[name]').filter(function() {
        return $(this).val() === '' && $(this).prop('name') !== 'q';
    }).remove();
});

//prop('name', '')