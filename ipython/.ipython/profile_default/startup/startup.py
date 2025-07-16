try:
    import ipdb
except ModuleNotFoundError:
    import pdb

try:
    import matplotlib.pyplot as plt
except ModuleNotFoundError:
    pass

try:
    import numpy as np
except ModuleNotFoundError:
    pass
# else:
#     np.set_printoptions(suppress=True, precision=3, linewidth=100)

try:
    import pandas as pd
except ModuleNotFoundError:
    pass
# else:
#     pd.options.display.width = 120
#     pd.options.display.precision = 4

from datetime import datetime, timedelta

# from IPython.core.getipython import get_ipython

# ipython = get_ipython()
# if ipython is not None:
#     ipython.run_line_magic("load_ext", "autoreload")
#     ipython.run_line_magic("autoreload", "2")
#     try:
#         ipython.run_line_magic("matplotlib", "inline")
#     except ModuleNotFoundError:
#         pass
# del ipython

# import logging
# logger = logging.getLogger()
# logging.basicConfig(
#     level="INFO",
#     format="%(asctime)s - %(levelname)-7s - %(module)-8s - %(message)s",
# )
