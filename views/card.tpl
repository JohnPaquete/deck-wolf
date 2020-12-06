% rebase('base.tpl')
% import viewtilities as util
<div class="container">
    <div class="mt-3">
        <h2>
            {{model.name}}
            <small class="text-muted">{{model.set_name}} [{{model.set_code}}]</small>
        </h2>
    </div>
    <div class="row mt-4">
        <div class="col-lg-4">
            <img class="w-100" src="{{model.image_uris.get('png')}}" alt="{{model.name}}">
            % if (model.artist is not None):
            <p class="mt-1 font-italic">Illustrated by {{model.artist}}</p>
            % end
            <button type="button" class="mt-1 btn btn-outline-primary w-100">Add to Collection</button>
        </div>
        <div class="col-lg-4">
            <div class="card">
                <div class="card-header h3">
                    {{model.name}}
                    {{model.mana_cost}}
                </div>
                <div class="card-body">
                    <p class="card-text font-weight-bold">{{model.type_line}}</p>
                    <p class="card-text">{{model.oracle_text}}</p>
                    % if (model.flavor_text is not None):
                    <p class="card-text font-italic">{{model.flavor_text}}</p>
                    % end
                    <hr></hr>
                    % if (model.power is not None and model.toughness is not None):
                    <p class="card-text">{{model.power}}/{{model.toughness}}</p>
                    <hr></hr>
                    % end
                    % if (model.loyalty is not None):
                    <p class="card-text">Loyalty: {{model.loyaly}}</p>
                    <hr></hr>
                    % end
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card">
                <div class="card-body">
                    % if (len(model.legalities) > 0):
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('standard'))}} p-1 rounded">{{util.legality(model.legalities.get('standard'))}}</div>
                            <div class="w-50 p-1 float-left">Standard</div>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('brawl'))}} p-1 rounded">{{util.legality(model.legalities.get('brawl'))}}</div>
                            <div class="w-50 p-1 float-left">Brawl</div>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('pioneer'))}} p-1 rounded">{{util.legality(model.legalities.get('pioneer'))}}</div>
                            <div class="w-50 p-1 float-left">Pioneer</div>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('historic'))}} p-1 rounded">{{util.legality(model.legalities.get('historic'))}}</div>
                            <div class="w-50 p-1 float-left">Historic</div>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('modern'))}} p-1 rounded">{{util.legality(model.legalities.get('modern'))}}</div>
                            <div class="w-50 p-1 float-left">Modern</div>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('pauper'))}} p-1 rounded">{{util.legality(model.legalities.get('pauper'))}}</div>
                            <div class="w-50 p-1 float-left">Pauper</div>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('legacy'))}} p-1 rounded">{{util.legality(model.legalities.get('legacy'))}}</div>
                            <div class="w-50 p-1 float-left">Legacy</div>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('penny'))}} p-1 rounded">{{util.legality(model.legalities.get('penny'))}}</div>
                            <div class="w-50 p-1 float-left">Penny</div>
                        </div>
                    </div>
                    <div class="row justify-content-around">
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('vintage'))}} p-1 rounded">{{util.legality(model.legalities.get('vintage'))}}</div>
                            <div class="w-50 p-1 float-left">Vintage</div>
                        </div>
                        <div class="col-lg mt-1 px-1 clearfix">
                            <div class="w-50 float-left text-center {{util.legality_bg(model.legalities.get('commander'))}} p-1 rounded">{{util.legality(model.legalities.get('commander'))}}</div>
                            <div class="w-50 p-1 float-left">Commander</div>
                        </div>
                    </div>
                    % end
                </div>
            </div>
        </div>
    </div>
</div>


