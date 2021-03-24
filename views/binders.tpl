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
            <div>
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
        <% 
        carousel_count = 0
        if (query.get('order') is not None):
            r = False
            if (query.get('direction') == 'desc'):
                r = True
            end
            if (query.get('order') == 'name'):
                model.cards.sort(key=lambda x: x.card.name, reverse=r)
            elif (query.get('order') == 'release'):
                model.cards.sort(key=lambda x: x.card.released, reverse=r)
            elif (query.get('order') == 'rarity'):
                model.cards.sort(key=lambda x: util.sort_by_rarity(x.card), reverse=r)
            elif (query.get('order') == 'cmc'):
                model.cards.sort(key=lambda x: x.card.cmc, reverse=r)
            elif (query.get('order') == 'color'):
                model.cards.sort(key=lambda x: x.card.color_identity, reverse=r)
            elif (query.get('order') == 'power'):
                model.cards.sort(key=lambda x: util.sort_by_power(x.card), reverse=r)
            elif (query.get('order') == 'toughness'):
                model.cards.sort(key=lambda x: util.sort_by_toughness(x.card), reverse=r)
            elif (query.get('order') == 'price'):
                model.cards.sort(key=lambda x: util.sort_by_price(x.card), reverse=r)
            end
        end
        %>

        % for bc in model.cards:
            % card = bc.card
        <div class="grid-item bg-black p-2 border border-secondary my-1">
            
            % if card.image_uris.get('normal') is not None:
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="{{card.image_uris.get('normal')}}" alt="{{card.name}}"></a>
            % elif card.faces is not None and len(card.faces) > 0:
                % include('partial/multi_card_grid_image.tpl')
                % carousel_count += 1
            % else:
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="/assets/img/card_back.jpg" alt="{{card.name}}"></a>
            % end
            <div class="mt-2 d-flex justify-content-between">
                <div>
                    % if model.binder.general == 0:
                        % if model.collection_totals[card.oracle_id]['owned'] < model.collection_totals[card.oracle_id]['needed']:
                            % text_class = "text-danger"
                        % else:
                            % text_class = "text-success"
                        % end
                    <span class="h4 mb-0 {{text_class}} font-weight-bold">{{model.collection_totals[card.oracle_id]['owned']}}/{{model.collection_totals[card.oracle_id]['needed']}}</span>
                    % else:
                        % if bc.collection.quantity < bc.quantity:
                            % text_class = "text-danger"
                        % else:
                            % text_class = "text-success"
                        % end
                    <span class="h4 mb-0 {{text_class}} font-weight-bold">{{bc.collection.quantity}}/{{bc.quantity}}</span>
                    % end
                    % if bc.cover == 1:
                    <span class="text-warning mr-2"></a><i class="fas fa-md fa-bookmark"></i></span>
                    % end
                </div>
                <div>
                    <a data-toggle="modal" data-target="#binder-card-edit-modal" data-name="{{card.name}}" data-id="{{card.id}}" data-quantity="{{bc.quantity}}" data-cover="{{bc.cover}}" href="/collection/binders/{{model.binder.id}}" class="text-primary" href=""><i class="fa fa-md fa-edit"></i></a>
                    <a data-toggle="modal" data-target="#binder-card-delete-modal" data-name="{{card.name}}" data-id="{{card.id}}" href="/collection/binders/{{model.binder.id}}" class="text-danger"><i class="fas fa-md fa-trash-alt"></i></a>
                </div>
            </div>
        </div>
        % end
        <div class="grid-item my-1">
        </div>
        <div class="grid-item my-1">
        </div>
        <div class="grid-item my-1">
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade binder-card-modal" id="binder-card-delete-modal" tabindex="-1" role="dialog" aria-labelledby="binder-card-delete-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="binder-card-delete-modal-label">Are you sure?</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <strong class="modal-info"></strong> will be removed from this binder.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <form class="modal-form" method="POST">
                    <input type="hidden" name="method" value="DELETE"> 
                    <input type="hidden" name="route" value="BINDERCARD">
                    <input type="hidden" name="redirect" value="/collection/binders/{{model.binder.id}}">
                    <input type="hidden" name="binder_id" value="{{model.binder.id}}">
                    <input class="card-id" type="hidden" name="card_id" value="">
                    <button type="submit" class="btn btn-danger">Confirm</button>
                </form>
            </div>
        </div>
    </div>
</div>
<div class="modal fade binder-card-modal" id="binder-card-edit-modal" tabindex="-1" role="dialog" aria-labelledby="binder-card-edit-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="binder-card-edit-modal-label">Edit: <strong class="modal-info"></strong></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form class="modal-form" method="POST">
                <input type="hidden" name="method" value="UPDATE"> 
                <input type="hidden" name="route" value="BINDERCARD">
                <input type="hidden" name="redirect" value="/collection/binders/{{model.binder.id}}">
                <input type="hidden" name="binder_id" value="{{model.binder.id}}">
                <input class="card-id" type="hidden" name="card_id" value="">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-md-9">
                            <label for="binder-quantity">Quantity:</label>
                            <input type="number" class="form-control rounded-right mr-1 card-quantity" name="quantity" id="binder-quantity" aria-describedby="binder-quantity" value="1" min="1">
                        </div>
                        <div class="form-group col-md-3">
                            <label for="binder-cover">Cover:</label>
                            <select class="custom-select card-cover" name="cover" id="binder-cover">
                                <option selected value="0">No</option>
                                <option value="1">Yes</option>
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
                <input type="hidden" name="route" value="BINDER">
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
<script src="/assets/js/binder_card_modal.js" type="text/javascript" defer></script>
<script src="/assets/js/edit_modal.js" type="text/javascript" defer></script>