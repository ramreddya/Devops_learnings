# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install the required packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code to the container
COPY app.py .

# Expose the port that the application will listen on
EXPOSE 5000

# Set the environment variable for Flask
ENV FLASK_APP=app.py

# Set the command to run the application
CMD ["flask", "run", "--host=0.0.0.0"]
