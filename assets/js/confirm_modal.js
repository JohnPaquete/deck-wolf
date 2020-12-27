$('#confirm-modal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var name = button.data('name')
    var quantity = button.data('quantity')
    var endpoint = button.attr('href')
    
    var modal = $(this)
    if (quantity != null)
      modal.find('.modal-info').text(quantity + ' ' + name)
    else
      modal.find('.modal-info').text(name)
    modal.find('.modal-form').attr('action', endpoint)
  })