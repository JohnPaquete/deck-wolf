% rebase('base.tpl')
% import src.viewtilities as util
% import math

% first = (model.page - 1) * model.cards_per_page
% last = min(first + model.cards_per_page, len(model.cards))
<div class="container">
    <div class="row mt-2">
        <div class="col-md d-flex">
            <i class="fa fa-fw fa-3x fa-search mr-2"></i>
            <div>
                <p class="h4 mb-0">{{len(model.cards)}} Cards Found <a class="text-primary" data-toggle="modal" data-target="#collection-modal" href="/collection/"><i class="fa fa-fw fa-archive"></i></a> <a class="text-primary" data-toggle="modal" data-target="#binder-modal" href="/collection/binders/"><i class="fas fa-book-open"></i></a></p>
                <p class="mb-0 text-muted">Displaying {{first + 1}}-{{last}}</p>
            </div>
        </div>
        <form class="col-md form-inline justify-content-end" method="GET">
            % for key in query:
                % if key != 'order' and key != 'direction':
            <input type="hidden" id="{{key}}" name="{{key}}" value="{{query.get(key)}}">
                % end
            % end
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
                model.cards.sort(key=lambda x: x.name, reverse=r)
            elif (query.get('order') == 'release'):
                model.cards.sort(key=lambda x: x.released, reverse=r)
            elif (query.get('order') == 'rarity'):
                model.cards.sort(key=util.sort_by_rarity, reverse=r)
            elif (query.get('order') == 'cmc'):
                model.cards.sort(key=lambda x: x.cmc, reverse=r)
            elif (query.get('order') == 'color'):
                model.cards.sort(key=lambda x: x.color_identity, reverse=r)
            elif (query.get('order') == 'power'):
                model.cards.sort(key=util.sort_by_power, reverse=r)
            elif (query.get('order') == 'toughness'):
                model.cards.sort(key=util.sort_by_toughness, reverse=r)
            elif (query.get('order') == 'price'):
                model.cards.sort(key=util.sort_by_price, reverse=r)
            end
        end
        %>

        % for x in range(first, last):
            % card = model.cards[x]
        <div class="grid-item my-1">
            % if (card.image_uris.get('normal') is not None):
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="{{card.image_uris.get('normal')}}" alt="{{card.name}}"></a>
            % elif (card.faces is not None and len(card.faces) > 0):
                % include('partial/multi_card_grid_image.tpl')
                % carousel_count += 1
            % else:
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="/assets/img/card_back.jpg" alt="{{card.name}}"></a>
            % end
        </div>
        % end
        <div class="grid-item my-1">
        </div>
        <div class="grid-item my-1">
        </div>
        <div class="grid-item my-1">
        </div>
    </div>
    % if (len(model.cards) > model.cards_per_page):
        % first = max(1, model.page - 2)
        % last = min(model.page + 2, math.ceil(len(model.cards)/model.cards_per_page))
    <nav aria-label="Page navigation" class="mt-3">
        <ul class="pagination justify-content-center">
        % if (model.page > 1):
        <li class="page-item">
        % else:
        <li class="page-item disabled">
        % end
            % if (model.page > 1):
            <a class="page-link" href="/search{{util.paginate(query, model.page - 1)}}" aria-label="Previous">Previous</a>
            % else:
            <span class="page-link">Previous</span>
            % end
        </li>
        % for x in range(first, last + 1):
            % if (x == model.page):
        <li class="page-item active"><a class="page-link" href="/search{{util.paginate(query, x)}}">{{x}}</a></li>
            % else:
        <li class="page-item"><a class="page-link" href="/search{{util.paginate(query, x)}}">{{x}}</a></li>
            % end
        % end

        % if (model.page < math.ceil(len(model.cards)/model.cards_per_page)):
        <li class="page-item">
        % else:
        <li class="page-item disabled">
        % end
            % if (model.page < math.ceil(len(model.cards)/model.cards_per_page)):
            <a class="page-link" href="/search{{util.paginate(query, model.page + 1)}}" aria-label="Previous">Next</a>
            % else:
            <span class="page-link">Next</span>
            % end
        </li>
        </ul>
    </nav>
    % end
</div>

<!-- Modal -->
<div class="modal fade" id="collection-modal" tabindex="-1" role="dialog" aria-labelledby="collection-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form class="modal-form" action="" method="POST">
                <input type="hidden" name="route" value="COLLECTION">
                <div class="modal-header">
                    <h5 class="modal-title" id="collection-modal-label">Are you sure?</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="modal-info mb-4"><strong>{{len(model.cards)}}</strong> cards will be added to your collection. Cards already in your collection will be ignored.</p>
                    <div class="row">
                        <label for="quantity" class="col-sm-2 col-form-label">Quantity</label>
                        <div class="col-sm-8">
                            <input type="number" class="form-control rounded-right mr-1" name="quantity" id="quantity" value="0" min="0">
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
<div class="modal fade" id="binder-modal" tabindex="-1" role="dialog" aria-labelledby="binder-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            % if len(binders) > 0:
            <form class="modal-form" action="" method="POST">
                <input type="hidden" name="route" value="BINDER">
                <div class="modal-header">
                    <h5 class="modal-title" id="binder-modal-label">Are you sure?</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="modal-info mb-4"><strong>{{len(model.cards)}}</strong> cards will be added to the selected binder. Cards already in the binder will be ignored.</p>
                    <div class="row mb-2">
                        <label for="binder_id" class="col-sm-2 col-form-label">Binder</label>
                        <div class="col-sm-8">
                            <select class="custom-select" name="binder_id" id="binder-id" required>
                                <option value="" selected disabled hidden>Select Binder</option>
                                % for b in binders:
                                <option value="{{b.id}}">{{b.name}}</option>
                                % end
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <label for="quantity" class="col-sm-2 col-form-label">Quantity</label>
                        <div class="col-sm-6">
                            <input type="number" class="form-control rounded-right mr-1" name="quantity" id="quantity" value="0" min="0">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-danger">Confirm</button>
                </div>
            </form>
            % else:
            <div class="modal-header">
                <h5 class="modal-title" id="binder-modal-label">Nothing to see here.</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p class="modal-info mb-4">You have not created any binders to add these cards to.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-danger">Confirm</button>
            </div>
            % end
        </div>
    </div>
</div>