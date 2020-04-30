from tensorflow.keras.models import load_model
import keras
from keras.preprocessing.sequence import pad_sequences
import pickle

MAX_LEN=50

class ModelWrapper:
    """
    This class should be used to load and invoke the serialized model and any other required
    model artifacts for pre/post-processing.
    """

    def __init__(self):
        """
        Load the model + required pre-processing artifacts from disk. Loading from disk is slow,
        so this is done in `__init__` rather than loading from disk on every call to `predict`.

        Use paths relative to the project root directory.

        Tensorflow example:

            self.model = load_model("models/model.h5")

        Pickle example:

            with open('models/tokenizer.pickle', 'rb') as handle:
                self.tokenizer = pickle.load(handle)
        """
        self.model = load_model("models/model.h5")
        with open('models/tokenizer.pickle', 'rb') as handle:
            self.tokenizer = pickle.load(handle)

    def predict(self,texts):
        """
        Returns model predictions.
        """
        sequences = self.tokenizer.texts_to_sequences(texts)
        processed_texts = pad_sequences(sequences,maxlen=MAX_LEN,truncating='post',padding='post')
        result = self.model.predict(processed_texts)
        print(texts,result)

        return result
