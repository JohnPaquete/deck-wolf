$('#edit-modal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var name = button.data('name')
    var general = button.data('general')
    var endpoint = button.attr('href')
    
    var modal = $(this)
    modal.find('#edit-name').val(name)
    modal.find('#edit-general').val(general)
    modal.find('.modal-form').attr('action', endpoint)
  })