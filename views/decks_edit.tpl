% rebase('base.tpl')
<div class="container">
    <form novalidate>
        <div class="form-row mb-2">
            <div class="col-md-4">
                <label for="name">Name</label>
                <input type="text" class="form-control" name="name" id="name" placeholder="Name" required>
                <div class="invalid-feedback">
                    Please choose a deck name.
                </div>
            </div>
            <div class="col-md-4">
                <label for="format">Format</label>
                <select class="custom-select" name="format" id="format" required>
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
            </div>
        </div>
        <div class="form-row mb-2">
            <div class="col-md-4">
                <label for="name">Commander</label>
                <input type="text" class="form-control" name="commander" id="commander" placeholder="">
            </div>
            <div class="col-md-4">
                <label for="name">Partner</label>
                <input type="text" class="form-control" name="partner" id="partner" placeholder="">
            </div>
            <div class="col-md-4">
                <label for="name">Companion</label>
                <input type="text" class="form-control" name="companion" id="companion" placeholder="">
            </div>
        </div>
        <button class="btn btn-primary" type="submit">Save</button>
    </form>
</div>