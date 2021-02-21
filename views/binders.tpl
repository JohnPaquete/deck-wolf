% rebase('base.tpl')
% import src.viewtilities as util

<div class="container">
    <div class="row mt-2">
        <div class="col-md-6 d-flex align-items-end">
            % if model.cover is not None:
            <td><div class="card-preview rounded mr-3" style="width: 8rem; height: 6rem;  background-image: url('{{util.card_image(model.cover, 'art_crop')}}');" data-placement="bottom" data-toggle="tooltip" title="{{model.cover.artist}}"></div></td>
            % else:
            <td><div class="card-preview rounded mr-3" style="width: 8rem; height: 6rem;  background-image: url('/assets/img/card_back.jpg');"></div></td>
            % end
            <div >
                <h1 class="mb-0">{{model.binder.name}} <a class="align-top h4 text-primary" data-toggle="modal" data-target="#edit-modal" data-name="{{model.binder.name}}" data-general="{{model.binder.general}}" href="/collection/binders/{{model.binder.id}}"><i class="fa fa-edit"></i></a></h1>
                <p class="mb-0 text-muted text-capitalize">{{util.is_general(model.binder.general)}} · Created {{model.binder.created.strftime("%a %b %d, %Y")}}</p>
            </div>
        </div>
        <div class="col-md-6">

        </div>
    </div>
    <hr class="my-2"></hr>
</div>
<div class="modal fade" id="edit-modal" tabindex="-1" role="dialog" aria-labelledby="edit-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="edit-modal-label">Edit Binder</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form class="modal-form" action="" method="POST">
                <input type="hidden" name="method" value="UPDATE"> 
                <div class="modal-body">
                    <div class="form-group form-row">
                        <div class="col-md-9">
                            <label for="edit-name" class="col-form-label">Name:</label>
                            <input type="text" class="form-control" name="name" id="edit-name" required>
                        </div>
                        <div class="col-md-3">
                            <label for="edit-general" class="col-form-label">Specific:</label>
                            <select class="custom-select" name="general" id="edit-general">
                                <option selected value="0">General</option>
                                <option value="1">Specific</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-danger">Confirm</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="/assets/js/edit_modal.js" type="text/javascript" defer></script>