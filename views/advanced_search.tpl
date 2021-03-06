% rebase('base.tpl')
% import src.viewtilities as util
<div class="container">
    <form class="my-2" action="/search/" method="GET" id='advanced-search'>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="name" class="col-sm-2 col-form-label"><i class="far fa-id-card mr-2"></i>Card Name</label>
            <div class="col-sm-6">
                <input type="text" class="form-control" name="q" id="name" placeholder="Black Lotus">
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="text" class="col-sm-2 col-form-label"><i class="fas fa-font mr-2"></i>Text</label>
            <div class="col-sm-6">
                <input type="text" class="form-control" name="text" id="text" placeholder="Mutate">
                <p class="mb-0 mt-1 font-italic text-muted">Filter by the text that appears in the rules box of the card.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="type" class="col-sm-2 col-form-label"><i class="fas fa-spider mr-2"></i>Type</label>
            <div class="col-sm-6">
                <input type="text" class="form-control" name="type" id="type" placeholder="Spider">
                <p class="mb-0 mt-1 font-italic text-muted">Filter by the text that appears in the type-line of the card.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="colors" class="col-sm-2 col-form-label"><i class="fas fa-palette mr-2"></i>Colors</label>
            <div class="col-sm-6 check-group" id="colors">
                <div class="d-flex">
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="color-white" id="customCheck1">
                        <label class="custom-control-label" for="customCheck1">White</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="color-blue" id="customCheck2">
                        <label class="custom-control-label" for="customCheck2">Blue</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="color-black" id="customCheck3">
                        <label class="custom-control-label" for="customCheck3">Black</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="color-red" id="customCheck4">
                        <label class="custom-control-label" for="customCheck4">Red</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="color-green" id="customCheck5">
                        <label class="custom-control-label" for="customCheck5">Green</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="color-colorless" id="customCheck6">
                        <label class="custom-control-label" for="customCheck6">Colorless</label>
                    </div>
                </div>
                <div class="row mt-2 mx-0">
                    <select class="custom-select col-md-3" name="color-filter" id="color-filter">
                        <option value="exact">Exact</option>
                        <option value="most">At Most</option>
                        <option value="including">Including</option>
                    </select>
                </div>
                <p class="mb-0 mt-1 font-italic text-muted">The colors of the mana cost of the card.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="stats" class="col-sm-2 col-form-label"><i class="fas fa-flask mr-2"></i>Stats</label>
            <div class="col-sm-6" id="stats">
                <div class="select-group row mb-1 mx-0">
                    <label for="cmc" class="col-sm-3 col-form-label"><i class="fas fa-magic mr-2"></i>CMC</label>
                    <div class="col-md-1"></div>
                    <select class="custom-select col-md-4" name="cmc-compare" id="cmc-compare">
                        <option value="eq">Equal To</option>
                        <option value="not-eq">Not Equal To</option>
                        <option value="less">Less Than</option>
                        <option value="less-or">Less Than Or Equal To</option>
                        <option value="great">Greater Than</option>
                        <option value="great-or">Greater Than Or Equal To</option>
                    </select>
                    <div class="col-md-1"></div>
                    <input type="number" class="form-control col-md-3 rounded-right" name="cmc" id="cmc" value="">
                </div>
                <div class="select-group row mb-1 mx-0">
                    <label for="power" class="col-sm-3 col-form-label"><i class="fas fa-fist-raised mr-2"></i>Power</label>
                    <div class="col-md-1"></div>
                    <select class="custom-select col-md-4" name="power-compare" id="power-compare">
                        <option value="eq">Equal To</option>
                        <option value="not-eq">Not Equal To</option>
                        <option value="less">Less Than</option>
                        <option value="less-or">Less Than Or Equal To</option>
                        <option value="great">Greater Than</option>
                        <option value="great-or">Greater Than Or Equal To</option>
                    </select>
                    <div class="col-md-1"></div>
                    <input type="number" class="form-control col-md-3 rounded-right" name="power" id="power" value="">
                </div>
                <div class="select-group row mb-1 mx-0">
                    <label for="toughness" class="col-sm-3 col-form-label"><i class="fas fa-dumbbell mr-2"></i>Toughness</label>
                    <div class="col-md-1"></div>
                    <select class="custom-select col-md-4" name="toughness-compare" id="toughness-compare">
                        <option value="eq">Equal To</option>
                        <option value="not-eq">Not Equal To</option>
                        <option value="less">Less Than</option>
                        <option value="less-or">Less Than Or Equal To</option>
                        <option value="great">Greater Than</option>
                        <option value="great-or">Greater Than Or Equal To</option>
                    </select>
                    <div class="col-md-1"></div>
                    <input type="number" class="form-control col-md-3 rounded-right" name="toughness" id="toughness" value="">
                </div>
                <div class="select-group row mx-0">
                    <label for="loyalty" class="col-sm-3 col-form-label"><i class="fas fa-crown mr-2"></i>Loyalty</label>
                    <div class="col-md-1"></div>
                    <select class="custom-select col-md-4" name="loyalty-compare" id="loyalty-compare">
                        <option value="eq">Equal To</option>
                        <option value="not-eq">Not Equal To</option>
                        <option value="less">Less Than</option>
                        <option value="less-or">Less Than Or Equal To</option>
                        <option value="great">Greater Than</option>
                        <option value="great-or">Greater Than Or Equal To</option>
                    </select>
                    <div class="col-md-1"></div>
                    <input type="number" class="form-control col-md-3 rounded-right" name="loyalty" id="loyalty" value="">
                </div>
                <p class="mb-0 mt-1 font-italic text-muted">The text that appears in the type-line of the card.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="formats" class="col-sm-2 col-form-label"><i class="fas fa-trophy mr-2"></i>Format</label>
            <div class="col-sm-6" id="formats">
                <div class="total-group row mx-0">
                    <select class="custom-select col-md-3" name="legality" id="legality">
                        <option value="legal">Legal</option>
                        <option value="restricted">Restricted</option>
                        <option value="banned">Banned</option>
                    </select>
                    <div class="col-md-1"></div>
                    <select class="custom-select col-md-5" name="format" id="format">
                        <option value=""></option>
                        <option value="standard">Standard</option>
                        <option value="pioneer">Pioneer</option>
                        <option value="modern">Modern</option>
                        <option value="legacy">Legacy</option>
                        <option value="vintage">Vintage</option>
                        <option value="brawl">Brawl</option>
                        <option value="historic">Historic</option>
                        <option value="pauper">Pauper</option>
                        <option value="penny">Penny Dreadful</option>
                        <option value="commander">Commander</option>
                    </select>
                </div>
                <p class="mb-0 mt-1 font-italic text-muted">Filter based on legality by format.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="type" class="col-sm-2 col-form-label"><i class="fas fa-layer-group mr-2"></i>Set</label>
            <div class="col-sm-6">
                <select class="custom-select col-md-8" name="set" id="set">
                    <option value=""></option>
                    % filtered_list = [s for s in model.sets if s.set_type == 'expansion' or s.set_type == 'core']
                    % filtered_list.sort(key=lambda x: x.released, reverse=True)
                    % for set in filtered_list:
                    <option value="{{set.code}}">{{set.name}} ({{set.code}})</option>
                    % end
                </select>
                <p class="mb-0 mt-1 font-italic text-muted">Filter cards based on their set.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3 border-bottom">
            <label for="type" class="col-sm-2 col-form-label"><i class="fas fa-award mr-2"></i>Rarity</label>
            <div class="col-sm-6">
                <div class="d-flex">
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="rarity-common" id="customCheck7">
                        <label class="custom-control-label" for="customCheck7">Common</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="rarity-uncommon" id="customCheck8">
                        <label class="custom-control-label" for="customCheck8">Uncommon</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="rarity-rare" id="customCheck9">
                        <label class="custom-control-label" for="customCheck9">Rare</label>
                    </div>
                    <div class="custom-control custom-checkbox mr-3">
                        <input type="checkbox" class="custom-control-input" name="rarity-mythic" id="customCheck10">
                        <label class="custom-control-label" for="customCheck10">Mythic</label>
                    </div>
                </div>
                <p class="mb-0 mt-1 font-italic text-muted">Filter by the rarity of a card.</p>
            </div>
        </div>
        <div class="form-group row mb-0 py-3">
            <div class="col-sm-2 col-form-label"></div>
            <div class="col-sm-6">
                <button class="btn btn-outline-primary" type="submit">Search</button>
            </div>
        </div>
    </form>
</div>
<script src="/assets/js/advanced_search.js" type="text/javascript" defer></script>