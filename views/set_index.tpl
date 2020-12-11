% rebase('base.tpl')
% import viewtilities as util
<div class="container">
    <div class="py-3">
        <form class="form-inline" method="GET">
            <label class="mr-sm-2" for="order">Order By</label>
            <select class="custom-select mr-sm-3" name="order" id="order">
                <option {{util.selected(order, 'release')}} value="release">Release Date</option>
                <option {{util.selected(order, 'name')}} value="name">Name</option>
                <option {{util.selected(order, 'cards')}} value="cards">Card Count</option>
            </select>
            <label class="mr-sm-2" for="type">Type</label>
            <select class="custom-select mr-sm-3" name="type" id="type">
                <option value="">All</option>
                % for t in model.set_types:
                    <option class="text-capitalize" {{util.selected(set_type, t)}} value="{{t}}">{{util.clean_text(t).title()}}</option>
                % end
            </select>
            <label class="mr-sm-2" for="name">Name</label>
            <input class="form-control mr-sm-3" type="text" name="name" placeholder="Search" value="{{name}}">
            <button class="btn btn-outline-primary" type="submit">Apply</button>
        </form>
    </div>
    <table class="table table-sm table-striped">
        <thead>
            <tr>
                <th>Name</th>
                <th>Release Date</th>
                <th>Card Count</th>
                <th>Type</th>
            </tr>
        </thead>
        <tbody>
            <% 
            filtered_list = model.sets
            if (set_type is not None):
                filtered_list = [item for item in filtered_list if item.set_type == set_type]
            end
            if (name is not None):
                filtered_list = [item for item in filtered_list if name.lower() in item.name.lower()]
            end
            if (order is not None):
                if (order == 'release'):
                    filtered_list.sort(key=lambda item: item.released, reverse=True)
                elif (order == 'name'):
                    filtered_list.sort(key=lambda item: item.name)
                elif (order == 'cards'):
                    filtered_list.sort(key=lambda item: item.card_count, reverse=True)
                else:
                    filtered_list.sort(key=lambda item: item.released, reverse=True)
                end
            end
            for s in filtered_list:
            %>
            <tr>
                <td><img class="mr-2" style="max-width:1rem; max-height:1rem; filter: invert(60%)" src="{{s.icon_svg_uri}}"></img><a class="mr-2 text-light" href="/sets/{{s.code}}"><span>{{s.name}}</span></a><span class="text-uppercase text-muted">{{s.code}}</span></td>
                <td>{{s.released}}</td>
                <td>{{s.card_count}}</td>
                <td class="text-capitalize">{{util.clean_text(s.set_type)}}</td>
            </tr>
            % end
        </tbody>
    </table>
</div>
