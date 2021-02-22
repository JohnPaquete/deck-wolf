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
        <div class="col-md-6 d-flex justify-content-end align-items-end">
            <form class="form-inline" method="GET">
                <label class="mr-sm-2" for="order">Order By</label>
                <select class="custom-select mr-sm-2" name="order" id="order">
                    <option {{util.selected(query.order, 'name')}} value="name">Name</option>
                    <option {{util.selected(query.order, 'release')}} value="release">Release Date</option>
                    <option {{util.selected(query.order, 'rarity')}} value="rarity">Rarity</option>
                    <option {{util.selected(query.order, 'cmc')}} value="cmc">CMC</option>
                    <option {{util.selected(query.order, 'color')}} value="color">Color</option>
                    <option {{util.selected(query.order, 'power')}} value="power">Power</option>
                    <option {{util.selected(query.order, 'toughness')}} value="toughness">Toughnes</option>
                    <option {{util.selected(query.order, 'price')}} value="price">Price</option>
                </select>
                <label class="mr-sm-2" for="direction">|</label>
                <select class="custom-select mr-sm-3" name="direction" id="direction">
                    <option {{util.selected(query.direction, 'asc')}} value="asc">Asc</option>
                    <option {{util.selected(query.direction, 'desc')}} value="desc">Desc</option>
                </select>
                <button class="btn btn-outline-primary" type="submit">Apply</button>
            </form>
        </div>
    </div>
    <hr class="my-2"></hr>
    <div class="d-flex flex-wrap justify-content-between">

    </div>
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
                <input type="hidden" name="redirect" value="/collection/binders/{{model.binder.id}}">
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