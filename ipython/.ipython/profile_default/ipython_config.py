c.InteractiveShellApp.exec_lines = [
    'import numpy as np',
    'import pandas as pd',
    # 'import matplotlib.pyplot as plt',
    'from datetime import datetime, timedelta',
    'np.set_printoptions(suppress=True, precision=3, linewidth=100)',
    'pd.options.display.width = 120',
    'pd.options.display.precision = 4',
    # '%load_ext line_profiler',
    # '%load_ext memory_profiler',
    '%load_ext autoreload',
    '%autoreload 2',
    'import logging',
    'logger = logging.getLogger()',
    'logging.basicConfig(level="INFO", format="%(asctime)s - %(levelname)-7s - " "%(module)-8s - %(message)s")',
]
