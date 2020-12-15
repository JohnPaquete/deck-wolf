% rebase('base.tpl')
% import viewtilities as util
% import math

<div class="container">
    <hr class="my-2"></hr>
    <div class="d-flex flex-wrap justify-content-between">
        %carousel_count = 0
        %first = (model.page - 1) * model.cards_per_page
        %last = min(first + model.cards_per_page, len(model.cards))

        % for x in range(first, last):
            % card = model.cards[x]
        <div class="grid-item my-1">
            % if (card.image_uris.get('normal') is not None):
            <a href="/cards/{{card.id}}"><img class="w-100 card-rounded" src="{{card.image_uris.get('normal')}}" alt="{{card.name}}"></a>
            % elif (card.faces is not None and len(card.faces) > 0):
                % include('multi_card_grid_image.tpl')
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
    <nav aria-label="Page navigation example">
        <ul class="pagination">
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