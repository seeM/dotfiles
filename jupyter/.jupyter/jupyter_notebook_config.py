def nbdev_clean_pre_save(model, **kwargs):
    from nbdev.clean import clean_nb
    if model['type'] != 'notebook' or model['content']['nbformat'] != 4: return
    clean_nb(model['content'])

c.FileContentsManager.pre_save_hook = nbdev_clean_pre_save
