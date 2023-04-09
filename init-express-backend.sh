#!/bin/bash

# Get the project name from the command line argument
project_name=$1

if [ -z "$project_name" ]; then
	  echo "Please provide a project name as the first argument."
		  exit 1
fi

# Create project folder and initialize
mkdir "$project_name"
cd "$project_name"
npm init -y

# Install dependencies
npm install express typescript ts-node nodemon cors mongoose @types/node @types/express @types/cors @types/mongoose

# Create and configure tsconfig.json
cat > tsconfig.json <<EOL
{
  "compilerOptions": {
	    "target": "es6",
	    "module": "commonjs",
	    "outDir": "./dist",
	    "strict": true,
	    "esModuleInterop": true,
	    "skipLibCheck": true,
	    "forceConsistentCasingInFileNames": true,
	    "moduleResolution": "node"
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules"]
}
EOL

# Create and configure nodemon.json
cat > nodemon.json <<EOL
{
  "watch": ["src"],
  "ext": "ts",
  "exec": "ts-node ./src/index.ts",
  "ignore": ["src/**/*.spec.ts"]
}
EOL


# Update package.json with scripts
npx json -I -f package.json -e 'this.scripts={"start": "nodemon", "build": "tsc", "serve": "node dist/index.js"}'

# Create directories and files
mkdir -p src/controllers src/models src/services src/routes
# Create index.ts with a sample code
cat > src/index.ts <<EOL
import express from 'express';
import cors from 'cors';
import mongoose from 'mongoose';
import { config } from 'dotenv';
import sampleRoutes from './routes/sampleRoutes';

config(); // Load environment variables

const app = express();
app.use(cors());
app.use(express.json());
app.use('/sample', sampleRoutes);

mongoose
	.connect(process.env.MONGODB_URI, (err) => {
    	if (err) {
	    	console.error(err);
			process.exit(1);
		}
		const port = process.env.PORT || 3000;
		app.listen(port, () => {
		    console.log(\`Server is running on port \$port\`);
		});
});
									
EOL

# Create a sample model
cat > src/models/sample.ts <<EOL
import { Schema, model } from 'mongoose';

interface Sample {
  value: number;
  description: string;
  date: Date;
  category: string;
}

const sampleSchema = new Schema<Sample>({
  value: { type: Number, required: true },
  description: { type: String, required: true },
  date: { type: Date, required: true },
  category: { type: String, required: true },
});

const SampleModel = model<Sample>('Sample', sampleSchema);
export { Sample, SampleModel };
EOL

# Create a sample service
cat > src/services/sampleService.ts <<EOL
import { Sample, SampleModel } from '../models/sample';

const getAllSamples = (): Promise<Sample[]> => {
  return SampleModel.find().exec();
};

const createSample = (sample: Sample): Promise<Sample> => {
  return new SampleModel(sample).save();
};

const getSampleById = (id: string): Promise<Sample | null> => {
  return SampleModel.findById(id).exec();
};

const updateSample = (id: string, sample: Sample): Promise<Sample | null> => {
  return SampleModel.findByIdAndUpdate(id, sample, { new: true }).exec();
};

const deleteSample = (id: string): Promise<Sample | null> => {
  return SampleModel.findByIdAndRemove(id).exec();
};

export { getAllSamples, createSample, getSampleById, updateSample, deleteSample };
EOL
	

# Create sample routes
cat > src/routes/sampleRoutes.ts <<EOL
import { Router } from 'express';
import * as SampleController from '../controllers/sampleController';

const router = Router();

router.get('/', SampleController.getAllSamples);
router.post('/', SampleController.createSample);
router.get('/:id', SampleController.getSampleById);
router.put('/:id', SampleController.updateSample);
router.delete('/:id', SampleController.deleteSample);

export default router;
EOL

# Create a sample controller
cat > src/controllers/sampleController.ts <<EOL
import { Request, Response } from 'express';
import * as SampleService from '../services/sampleService';

export const getAllSamples = async (req: Request, res: Response): Promise<void> => {
  try {
	    const samples = await SampleService.getAllSamples();
      res.status(200).json(samples);
	} catch (error: any) {
	    res.status(500).json({ error: error.message });
  }
};

export const createSample = async (req: Request, res: Response): Promise<void> => {
  try {
		const sample = await SampleService.createSample(req.body);
		res.status(201).json(sample);
	} catch (error: any) {
		res.status(500).json({ error: error.message });
	}
};

export const getSampleById = async (req: Request, res: Response): Promise<void> => {
	try {
		const sample = await SampleService.getSampleById(req.params.id);
		if (sample) {
			res.status(200).json(sample);
		} else {
			res.status(404).json({ error: 'Sample not found' });
		} catch (error: any) {
			res.status(500).json({ error: error.message });
		}
	};

export const updateSample = async (req: Request, res: Response): Promise<void> => {
   try {
	    const sample = await SampleService.updateSample(req.params.id, req.body);
		if (sample) {
			res.status(200).json(sample);
		} else {
			res.status(404).json({ error: 'Sample not found' });
		}
	} catch (error: any) {
		res.status(500).json({ error: error.message });
	}
;

export const deleteSample = async (req: Request, res: Response): Promise<void> => {
	try {
		const sample = await SampleService.deleteSample(req.params.id);
		if (sample) {
			res.status(200).json
		}
		if (sample) {
			res.status(200).json(sample);
		} else {
			res.status(404).json({ error: 'Sample not found' });
		}
	} catch (error: any) {
		res.status(500).json({ error: error.message });
	}
};
EOL