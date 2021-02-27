$('#binder-card-modal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var name = button.data('name')
    var id = button.data('id')
    var endpoint = button.attr('href')
    
    var modal = $(this)
    modal.find('.modal-info').text(name)
    modal.find('.card-id').val(id)
    modal.find('.modal-form').attr('action', endpoint)
  })