def nbdev_clean_pre_save(model, path=None, contents_manager=None):
    from nbdev.clean import clean_nb
    if model['type'] != 'notebook' or model['content']['nbformat'] != 4: return
    clean_nb(model['content'])

c.ContentsManager.pre_save_hook = nbdev_clean_pre_save
