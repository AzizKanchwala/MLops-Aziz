from mlProject.config.configuration import ConfigurationManager
from mlProject.components.model_trainer import ModelTrainer
from mlProject import logger
from pathlib import Path
import os

STAGE_NAME = "Model training Stage"
class ModelPipeline:
    def __init__(self):
        pass

    def main(self):
        base_path = Path("artifacts/data_transformation")
        required_files = ["train.csv", "test.csv"]

        missing_files = []

        for file in required_files:
            file_path = base_path / file
            if not file_path.exists():
                missing_files.append(file)
            else:
                try:
                    with open(file_path, "r") as f:
                        pass
                except Exception as e:
                    print(f"Error opening {file}: {e}")
                    missing_files.append(file)

        if not missing_files:
            config = ConfigurationManager()
            trainer_config = config.get_model_trainer_config()
            training = ModelTrainer(config=trainer_config)
            try:
                training.train()
                logger.info("Model training succeeded")
            except:
                logger.error("Model training Failed !!")

        else:
            raise Exception("Training and test files not present in data transformation directory")
        

if __name__ == '__main__':
    try:
        logger.info(f">>>>>> stage {STAGE_NAME} started <<<<<<")
        obj = ModelPipeline()
        obj.main()
        logger.info(f">>>>>> stage {STAGE_NAME} completed <<<<<<\n\nx==========x")
    except Exception as e:
        logger.exception(e)
        raise e