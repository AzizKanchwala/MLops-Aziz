from mlProject.config.configuration import ConfigurationManager
from mlProject.components.data_transformation import DataTransformation
from mlProject import logger

STAGE_NAME = "Data Validation Stage"
class DataTransformationTrainingPipeline:
    def __init__(self):
        pass

    def main(self):
        config = ConfigurationManager()
        data_transformation_config = config.get_data_transformation_config()
        transformation_class = DataTransformation(data_transformation_config)
        try:
            transformation_class.train_test_spliting()
            logger.info("Data transformation logic succeeded!")
        except:
            logger.error("Data Transformation Failed!!")
        

if __name__ == '__main__':
    try:
        logger.info(f">>>>>> stage {STAGE_NAME} started <<<<<<")
        obj = DataTransformationTrainingPipeline()
        obj.main()
        logger.info(f">>>>>> stage {STAGE_NAME} completed <<<<<<\n\nx==========x")
    except Exception as e:
        logger.exception(e)
        raise e