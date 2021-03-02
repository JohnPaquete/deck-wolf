$('.binder-card-modal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget) // Button that triggered the modal
    var name = button.data('name')
    var quantity = button.data('quantity')
    var cover = button.data('cover')
    var id = button.data('id')
    var endpoint = button.attr('href')
    
    var modal = $(this)
    modal.find('.modal-info').text(name)
    if (quantity != null)
      modal.find('.card-quantity').val(quantity)
    if (cover != null)
      modal.find('.card-cover').val(cover)
    modal.find('.card-id').val(id)
    modal.find('.modal-form').attr('action', endpoint)
  })