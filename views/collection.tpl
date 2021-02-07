% rebase('base.tpl')
% import src.viewtilities as util
% import math

<%
filtered_list = model.cards
if (query.name != ''):
    filtered_list = [item for item in filtered_list if query.name.lower() in item.card.name.lower()]
end
if (query.get('order') is not None):
    r = False
    if (query.get('direction') == 'desc'):
        r = True
    end
    if (query.get('order') == 'name'):
        filtered_list.sort(key=lambda x: x.card.name, reverse=r)
    elif (query.get('order') == 'set'):
        filtered_list.sort(key=lambda x: x.card_set.name, reverse=r)
    elif (query.get('order') == 'release'):
        filtered_list.sort(key=lambda x: x.card.released, reverse=r)
    elif (query.get('order') == 'rarity'):
        filtered_list.sort(key=util.sort_full_card_by_rarity, reverse=r)
    elif (query.get('order') == 'quantity'):
        filtered_list.sort(key=lambda x: x.collection.quantity, reverse=r)
    end
end
%>

% first = (model.page - 1) * model.cards_per_page
% last = min(first + model.cards_per_page, len(filtered_list))
<div class="container">
    <div class="row py-2">
        <div class="col-md d-flex">
            <i class="fa fa-fw fa-3x fa-archive mr-2"></i>
            <div>
                <p class="h4 mb-0">{{len(model.cards)}} Cards in Your Collection</p>
                <p class="mb-0 text-muted">Total Value of ${{util.total_price_usd(model.cards)}} USD</p>
            </div>
        </div>
        <form class="col-md-8 form-inline justify-content-end" method="GET">
            <label class="mr-sm-2" for="order">Order By</label>
            <select class="custom-select mr-sm-2" name="order" id="order">
                <option {{util.selected(query.order, 'name')}} value="name">Name</option>
                <option {{util.selected(query.order, 'set')}} value="set">Set</option>
                <option {{util.selected(query.order, 'release')}} value="release">Release Date</option>
                <option {{util.selected(query.order, 'rarity')}} value="rarity">Rarity</option>
                <option {{util.selected(query.order, 'quantity')}} value="quantity">Quantity</option>
            </select>
            <label class="mr-sm-2" for="direction">|</label>
            <select class="custom-select mr-sm-3" name="direction" id="direction">
                <option {{util.selected(query.direction, 'asc')}} value="asc">Asc</option>
                <option {{util.selected(query.direction, 'desc')}} value="desc">Desc</option>
            </select>
            <input class="form-control mr-sm-3" type="text" name="name" placeholder="Search" value="{{query.name}}">
            <button class="btn btn-outline-primary" type="submit">Apply</button>
        </form>
    </div>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Preview</th>
                <th>Name</th>
                <th>Set</th>
                <th>Rarity</th>
                <th>Release Date</th>
                <th>Quantity</th>
                <th>Edit</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody>
            % for x in range(first, last):
                % fc = filtered_list[x]
            <tr>
                <td><div class="card-preview" style="width: 5.5rem; height: 4rem;  background-image: url('{{util.full_card_image(fc, 'art_crop')}}');" data-placement="bottom" data-toggle="tooltip" title="{{fc.card.artist}}"></div></td>
                <td class="align-middle"><a href="/cards/{{fc.card.id}}">{{fc.card.name}}</a></td>
                <td class="align-middle"><a href="/sets/{{fc.card_set.code}}">{{fc.card.set_name}}</a></td>
                <td class="align-middle">{{util.rarity(fc.card.rarity)}}</td>
                <td class="align-middle">{{fc.card.released}}</td>
                <td class="align-middle">{{fc.collection.quantity}}</td>
                <td class="align-middle text-center"><a href="/cards/{{fc.card.id}}"><i class="fa fa-lg fa-edit"></i></a></td>
                <td class="align-middle text-center"><a data-toggle="modal" data-target="#confirm-modal" data-name="{{fc.card.name}}" data-quantity="{{fc.collection.quantity}}" href="/collection/{{fc.collection.id}}"><i class="fa fa-lg fa-trash"></i></a></td>
            </tr>
            % end
        </tbody>
    </table>
    % if (len(filtered_list) > model.cards_per_page):
        % first = max(1, model.page - 2)
        % last = min(model.page + 2, math.ceil(len(filtered_list)/model.cards_per_page))
    <nav aria-label="Page navigation" class="mt-3">
        <ul class="pagination justify-content-center">
        % if (model.page > 1):
        <li class="page-item">
        % else:
        <li class="page-item disabled">
        % end
            % if (model.page > 1):
            <a class="page-link" href="/collection{{util.paginate(query, model.page - 1)}}" aria-label="Previous">Previous</a>
            % else:
            <span class="page-link">Previous</span>
            % end
        </li>
        % for x in range(first, last + 1):
            % if (x == model.page):
        <li class="page-item active"><a class="page-link" href="/collection{{util.paginate(query, x)}}">{{x}}</a></li>
            % else:
        <li class="page-item"><a class="page-link" href="/collection{{util.paginate(query, x)}}">{{x}}</a></li>
            % end
        % end

        % if (model.page < math.ceil(len(filtered_list)/model.cards_per_page)):
        <li class="page-item">
        % else:
        <li class="page-item disabled">
        % end
            % if (model.page < math.ceil(len(filtered_list)/model.cards_per_page)):
            <a class="page-link" href="/collection{{util.paginate(query, model.page + 1)}}" aria-label="Next">Next</a>
            % else:
            <span class="page-link">Next</span>
            % end
        </li>
        </ul>
    </nav>
    % end
</div>

<!-- Modal -->
<div class="modal fade" id="confirm-modal" tabindex="-1" role="dialog" aria-labelledby="confirm-modal-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="confirm-modal-label">Are you sure?</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <strong class="modal-info"></strong> will be removed from your collection.
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <form class="modal-form" action="" method="POST">
                <input type="hidden" name="method" value="DELETE"> 
                <button type="submit" class="btn btn-danger">Confirm</button>
            </form>
        </div>
        </div>
    </div>
</div>
<script src="/assets/js/confirm_modal.js" type="text/javascript" defer></script>