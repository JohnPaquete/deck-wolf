% rebase('base.tpl')
<div class="container">
    <form novalidate method="POST">
        <div class="form-row my-2 justify-content-around">
            <div class="col-md-6">
                <label for="name">Name</label>
                <input type="text" class="form-control mb-2" name="name" id="name" placeholder="Name" required>
                <div class="invalid-feedback">
                    Please choose a deck name.
                </div>

                <label for="format">Format</label>
                <select class="custom-select mb-2" name="format" id="format">
                    <option value="standard">Standard</option>
                    <option value="brawl">Brawl</option>
                    <option value="pioneer">Pioneer</option>
                    <option value="historic">Historic</option>
                    <option value="modern">Modern</option>
                    <option value="pauper">Pauper</option>
                    <option value="penny">Penny</option>
                    <option value="vintage">Vintage</option>
                    <option value="commander">Commander</option>
                </select>

                <label for="companion">Companion</label>
                <input type="text" class="form-control card-autocomplete mb-2" name="companion" id="companion" placeholder="">
                <div class="commander-row collapse">
                    <label for="commander">Commander</label>
                    <input type="text" class="form-control card-autocomplete mb-2" name="commander" id="commander" placeholder="">

                    <label for="partner">Partner</label>
                    <input type="text" class="form-control card-autocomplete mb-2" name="partner" id="partner" placeholder="">
                </div>
                <button class="btn btn-primary" type="submit">Save</button>
            </div>
            <div class="col-md-5">
                <ul class="nav nav-tabs">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#maindeck-content">Maindeck</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#sideboard-content">Sideboard</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div id="maindeck-content" class="tab-pane active">
                        <textarea class="form-control mb-2" name="maindeck" id="maindeck" rows="10"></textarea>
                        <input type="text" class="form-control card-autocomplete mb-2" name="maindeck-search" id="maindeck-search" placeholder="" aria-label="Search maindeck">
                        <div class="form-row mb-2">
                            <div class="col-md-9 d-flex align-items-center">
                                <label class="mb-0 mr-2" for="quantity">Qty.</label>
                                <input type="number" class="form-control" name="maindeck-quantity" id="maindeck-quantity" min="1" value="1">
                            </div>
                            <div class="col-md-3 d-flex justify-content-end">
                                <button type="button" class="btn btn-primary deck-add" data-target="#maindeck">Add</button>
                            </div>
                        </div>
                    </div>
                    <div id="sideboard-content" class="tab-pane">
                        <textarea class="form-control mb-2" name="sideboard" id="sideboard" rows="10"></textarea>
                        <input type="text" class="form-control card-autocomplete mb-2" name="sideboard-search" id="sideboard-search" placeholder="" aria-label="Search sideboard">
                        <div class="form-row mb-2">
                            <div class="col-md-9 d-flex align-items-center">
                                <label class="mb-0 mr-2" for="sideboard-quantity">Qty.</label>
                                <input type="number" class="form-control" name="sideboard-quantity" id="sideboard-quantity" min="1" value="1">
                            </div>
                            <div class="col-md-3 d-flex justify-content-end">
                                <button type="button" class="btn btn-primary deck-add" data-target="#sideboard">Add</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<script src="/assets/js/deck_builder.js" type="text/javascript" defer></script>