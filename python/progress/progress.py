import os
import multiprocessing as mp
import _thread as thread
from time import sleep, perf_counter as clock

try:
    import colorama
    colorama.init()
    os.system("")
    GREEN = lambda s: f"{colorama.Fore.GREEN}{s}{colorama.Style.RESET_ALL}"
    YELLOW = lambda s: f"{colorama.Fore.YELLOW}{s}{colorama.Style.RESET_ALL}"
    RED = lambda s: f"{colorama.Fore.RED}{s}{colorama.Style.RESET_ALL}"
except ImportError:
    GREEN = YELLOW = RED = lambda s: s

class Progress:
    """ 
    Example
    -------
    >>> ptrack = Progress(total)
    >>> ptrack.display()
    ... ...
    >>> next(ptrack)
    """

    __slots__ = (
        'text', '__lapse', '__total', '__done_lock', '__done', '_done', '__fail', '__fail_lock',
        '__start_time', '__last_length', '__finished', '__wait_lock', '__waiting',
    )

    STEPS = 24

    def __init__(self, total: int, lapse: float=None, text: str='Progress:'):
        ## Some text
        self.text = text

        ## Update Lapse
        self.__lapse = 0.5 if lapse is None else lapse

        ## Total steps
        self.__total = total

        ## Lock for progress track
        self.__done_lock = mp.Lock()
        self.__done = mp.Value('i', 0)

        ## Lock for failure rate
        self.__fail_lock = mp.Lock()
        self.__fail = mp.Value('i', 0)

        self.__start_time = clock()

        ## Previous output string lenght
        self.__last_length = 0

        ## Finished
        self.__finished = False

        ## Waiting
        self.__wait_lock = mp.Lock()
        self.__waiting = False
        
        print(self, end='\r')

    @property
    def done_lock(self):
        return self.__done_lock

    @property
    def wait_lock(self):
        return self.__wait_lock

    @property
    def fail_lock(self):
        return self.__fail_lock

    @property
    def total(self):
        return self.__total

    def start(self):
        self.__start_time = clock()

    @property
    def done(self):
        with self.done_lock: return self.__done.value

    @property
    def fail(self):
        with self.fail_lock: return self.__fail.value

    @property
    def start_time(self):
        return self.__start_time
    
    @property
    def total_time(self):
        return clock() - self.start_time

    @property
    def finished(self):
        return self.__finished or (self.done >= self.total)

    @property
    def waiting(self):
        return self.__waiting

    def __enter__(self, *args, **kwargs):
        self.track()
        return self

    def __exit__(self, *args, **kwargs):
        self.finish()

    def __next__(self):
        if not self.finished:
            with self.done_lock:
                self.__done.value += 1
            if self.waiting and self.finished:
                self.wait_lock.release()
                self.waiting = False
        else:
            raise StopIteration

    def fault(self):
        """Accounts for failure in your process.

        Example
        -------
        >>> if went_wrong():
        ...     prog.fault()
        ... else:
        ...     next(prog)
        """
        with self.fail_lock:
            self.__fail.value += 1
        self.__next__()

    def display(self):
        self.start()
        while not self.finished:
            self.update()
            sleep(self.__lapse)
        else:
            self.update()
            

    def finish(self):
        print(f'\nTime elapsed: {self.total_time:.1f}s')
        self.__finished = True
            
    def track(self, lapse:float=None) -> int:
        if lapse is not None: 
            self.__lapse = lapse
        return thread.start_new(self.display, ())

    def wait(self):
        self.__waiting = True
        self.wait_lock.acquire()
        while not self.finished:
            self.__wait_lock.acquire()

    @property
    def end(self):
        return '\n' if self.finished else '\r'

    def update(self):
        print(self, self.padding, end=self.end)
        self.__last_length = self.length
        
    def __str__(self):
        """ output string;
        """
        return f'{self.text} {self.bar} {self.done}/{self.total} {100 * self.ratio:2.2f}% eta: {self.eta} rate: {self.rate:.2f}/s @ {self.health}'

    @property
    def padding(self):
        """ padding needed to erase previous output;
        """
        return " " * (self.__last_length - self.length)

    @property
    def length(self):
        """ output string lenght;
        """
        return len(str(self))

    @property
    def ratio(self) -> float:
        """ progress ratio; value in [0, 1]
        """
        return self.done / self.total

    @property
    def rate(self):
        """ steps per second;
        """
        return self.done / self.total_time

    @property
    def success(self):
        """
        """
        return 1.0 - self.failure

    @property
    def failure(self):
        """
        """
        done = self.done
        if not done:
            return 0.0
        else:
            return self.fail / self.done

    @property
    def health(self):
        """
        """
        s = self.success
        if s > .75:
            return GREEN(f"{100.0 * s:.2f}%")
        elif s > .25:
            return YELLOW(f"{100.0 * s:.2f}%")
        else:
            return RED(f"{100.0 * s:.2f}%")
    
    @property
    def eta(self) -> str:
        if not self.done:
            return "?"
        s = (self.total_time / self.done) * (self.total - self.done)
        return self.hms(s)
    
    @staticmethod
    def hms(s: float) -> str:
        if s >= 60:
            m, s = divmod(s, 60)
            if m >= 60:
                h, m = divmod(m, 60)
                if h >= 24:
                    d, h = divmod(h, 24)
                    return f"{int(d):d}d{int(h):d}h{int(m):d}m{int(s):d}s"
                else:
                    return f"{int(h):d}h{int(m):d}m{int(s):d}s"
            else:
                return f"{int(m):d}m{int(s):d}s"
        else:
            return f"{int(s):d}s"

    @property
    def bar(self) -> str:
        if self.ratio == 0.0:
            return f"[{' ' * self.STEPS}]"
        elif self.ratio < 1:
            return f"[{int(self.ratio * self.STEPS) * '='}>{int((1 - self.ratio) * self.STEPS) * ' '}]"
        else:
            return f"[{'=' * self.STEPS}]"