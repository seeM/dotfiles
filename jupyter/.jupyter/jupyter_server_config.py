def nbdev_clean_jupyter(**kwargs):
    try: from nbdev.clean import clean_jupyter
    except ModuleNotFoundError: return
    clean_jupyter(**kwargs)

c.ContentsManager.pre_save_hook = nbdev_clean_jupyter