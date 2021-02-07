% rebase('base.tpl')
% import src.viewtilities as util
% import math

<%
filtered_list = model.preview_decks
if (query.name != ''):
    filtered_list = [item for item in filtered_list if query.name.lower() in item.deck.name.lower()]
end
if (query.get('order') is not None):
    r = False
    if (query.get('direction') == 'desc'):
        r = True
    end
    if (query.get('order') == 'name'):
        filtered_list.sort(key=lambda x: x.deck.name, reverse=r)
    elif (query.get('order') == 'created'):
        filtered_list.sort(key=lambda x: x.deck.created, reverse=r)
    elif (query.get('order') == 'format'):
        filtered_list.sort(key=lambda x: x.deck.format, reverse=r)
    end
end
%>

% first = (model.page - 1) * model.decks_per_page
% last = min(first + model.decks_per_page, len(filtered_list))
<div class="container">
    <div class="row py-2">
        <div class="col-md d-flex">
            <i class="fa fa-fw fa-3x fa-box mr-2"></i>
            <div>
                <p class="h4 mb-0">{{len(model.preview_decks)}} Decks in Your Library <a class="ml-1 text-primary" href="/decks/create"><i class="far fa-plus-square"></i></a></p>
                <p class="mb-0 text-muted">Placeholder</p>
            </div>
        </div>
        <form class="col-md-7 form-inline justify-content-end" method="GET">
            <label class="mr-sm-2" for="order">Order By</label>
            <select class="custom-select mr-sm-2" name="order" id="order">
                <option {{util.selected(query.order, 'name')}} value="name">Name</option>
                <option {{util.selected(query.order, 'created')}} value="created">Created</option>
                <option {{util.selected(query.order, 'format')}} value="format">Format</option>
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
                <th>Created</th>
                <th>Updated</th>
                <th>Format</th>
                <th>Status</th>
                <th>Edit</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody>
            % for x in range(first, last):
                % fd = filtered_list[x]
            <tr>
                <td><div class="card-preview" style="width: 5.5rem; height: 4rem;  background-image: url('/assets/img/card_back.jpg');" data-placement="bottom" data-toggle="tooltip" title="placeholder"></div></td>
                <td class="align-middle"><a href="/decks/{{fd.deck.id}}">{{fd.deck.name}}</a></td>
                <td class="align-middle">{{fd.deck.created.strftime("%a %b %d, %Y %I:%M:%S %p")}}</a></td>
                <td class="align-middle">{{fd.deck.updated.strftime("%a %b %d, %Y %I:%M:%S %p")}}</td>
                <td class="align-middle text-capitalize">{{fd.deck.format}}</td>
                <td class="align-middle">{{util.is_valid(fd.deck.valid)}}</td>
                <td class="align-middle text-center"><a href="/decks/edit/{{fd.deck.id}}"><i class="fa fa-lg fa-edit"></i></a></td>
                <td class="align-middle text-center"><a data-toggle="modal" data-target="#confirm-modal" data-name="{{fd.deck.name}}" href="/decks/{{fd.deck.id}}"><i class="fa fa-lg fa-trash"></i></a></td>
            </tr>
            % end
        </tbody>
    </table>
    % if (len(filtered_list) > model.decks_per_page):
        % first = max(1, model.page - 2)
        % last = min(model.page + 2, math.ceil(len(filtered_list)/model.decks_per_page))
    <nav aria-label="Page navigation" class="mt-3">
        <ul class="pagination justify-content-center">
        % if (model.page > 1):
        <li class="page-item">
        % else:
        <li class="page-item disabled">
        % end
            % if (model.page > 1):
            <a class="page-link" href="/decks{{util.paginate(query, model.page - 1)}}" aria-label="Previous">Previous</a>
            % else:
            <span class="page-link">Previous</span>
            % end
        </li>
        % for x in range(first, last + 1):
            % if (x == model.page):
        <li class="page-item active"><a class="page-link" href="/decks{{util.paginate(query, x)}}">{{x}}</a></li>
            % else:
        <li class="page-item"><a class="page-link" href="/decks{{util.paginate(query, x)}}">{{x}}</a></li>
            % end
        % end

        % if (model.page < math.ceil(len(filtered_list)/model.decks_per_page)):
        <li class="page-item">
        % else:
        <li class="page-item disabled">
        % end
            % if (model.page < math.ceil(len(filtered_list)/model.decks_per_page)):
            <a class="page-link" href="/decks{{util.paginate(query, model.page + 1)}}" aria-label="Next">Next</a>
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
            <strong class="modal-info"></strong> will be deleted.
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