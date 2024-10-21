FROM python:3.14.0a1-alpine3.19
WORKDIR /app
COPY app.py .
RUN pip install flask
EXPOSE 5000
ENTRYPOINT ["python", "app.py"]
